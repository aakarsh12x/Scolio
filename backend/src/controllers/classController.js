const databaseService = require('../services/databaseService');
const { catchAsync, AppError } = require('../middleware/errorHandler');
const { validateClass, validateClassUpdate } = require('../validators/classValidator');
const moment = require('moment');

class ClassController {
  // Get all classes with pagination
  getAllClasses = catchAsync(async (req, res) => {
    const {
      page = 1,
      limit = 20,
      academicYear,
      isActive = true,
      sortBy = 'createdAt',
      sortOrder = 'DESC'
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: { isActive: isActive === 'true' }
    };

    // Filter by academic year if provided
    if (academicYear) {
      options.where.academicYear = academicYear;
    }

    const result = await databaseService.paginate('Classes', options);

    // Get teacher information for each class
    const classesWithTeacherInfo = await Promise.all(
      result.data.map(async (classEntity) => {
        let teacherInfo = null;
        if (classEntity.teacherId) {
          const teacher = await databaseService.findById('Teachers', classEntity.teacherId);
          if (teacher) {
            const user = await databaseService.findOne('Users', { username: teacher.username });
            teacherInfo = {
              ...teacher,
              userInfo: user ? {
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email
              } : null
            };
          }
        }

        // Get student count for each class
        const students = await databaseService.findByCondition('Students', { 
          classId: classEntity.id,
          isActive: true 
        });

        return {
          ...classEntity,
          teacherInfo,
          studentCount: students.length
        };
      })
    );

    res.paginated(classesWithTeacherInfo, result.pagination, 'Classes retrieved successfully');
  });

  // Get class by ID
  getClassById = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    const classEntity = await databaseService.findById('Classes', id);
    
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Get teacher information
    let teacherInfo = null;
    if (classEntity.teacherId) {
      const teacher = await databaseService.findById('Teachers', classEntity.teacherId);
      if (teacher) {
        const user = await databaseService.findOne('Users', { username: teacher.username });
        teacherInfo = {
          ...teacher,
          userInfo: user ? {
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email
          } : null
        };
      }
    }

    // Get student count
    const students = await databaseService.findByCondition('Students', { 
      classId: id,
      isActive: true 
    });

    const classWithInfo = {
      ...classEntity,
      teacherInfo,
      studentCount: students.length
    };

    res.success(classWithInfo, 'Class retrieved successfully');
  });

  // Create new class
  createClass = catchAsync(async (req, res) => {
    // Validate input
    const { error, value } = validateClass(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if class with same name and academic year already exists
    const existingClass = await databaseService.findOne('Classes', { 
      name: value.name,
      section: value.section,
      academicYear: value.academicYear
    });

    if (existingClass) {
      throw new AppError('Class with this name, section and academic year already exists', 409);
    }

    // Check if teacher exists if provided
    if (value.teacherId) {
      const teacher = await databaseService.findById('Teachers', value.teacherId);
      if (!teacher) {
        throw new AppError('Teacher not found', 404);
      }
    }

    // Prepare class data
    const classData = {
      ...value,
      isActive: true,
      createdAt: moment().toISOString(),
      updatedAt: moment().toISOString()
    };

    // Create class
    const newClass = await databaseService.create('Classes', classData);

    res.created(newClass, 'Class created successfully');
  });

  // Update class
  updateClass = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    // Validate input
    const { error, value } = validateClassUpdate(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if class exists
    const existingClass = await databaseService.findById('Classes', id);
    if (!existingClass) {
      throw new AppError('Class not found', 404);
    }

    // Check if teacher exists if provided
    if (value.teacherId) {
      const teacher = await databaseService.findById('Teachers', value.teacherId);
      if (!teacher) {
        throw new AppError('Teacher not found', 404);
      }
    }

    // Check if class with same name and academic year already exists (if name or academic year is being updated)
    if ((value.name && value.name !== existingClass.name) || 
        (value.section && value.section !== existingClass.section) || 
        (value.academicYear && value.academicYear !== existingClass.academicYear)) {
      
      const nameToCheck = value.name || existingClass.name;
      const sectionToCheck = value.section || existingClass.section;
      const yearToCheck = value.academicYear || existingClass.academicYear;
      
      const duplicateClass = await databaseService.findOne('Classes', { 
        name: nameToCheck,
        section: sectionToCheck,
        academicYear: yearToCheck
      });

      if (duplicateClass && duplicateClass.id !== id) {
        throw new AppError('Class with this name, section and academic year already exists', 409);
      }
    }

    // Update class with timestamp
    const updateData = {
      ...value,
      updatedAt: moment().toISOString()
    };

    const updatedClass = await databaseService.update('Classes', id, updateData);

    res.updated(updatedClass, 'Class updated successfully');
  });

  // Delete class (soft delete)
  deleteClass = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if class exists
    const existingClass = await databaseService.findById('Classes', id);
    if (!existingClass) {
      throw new AppError('Class not found', 404);
    }

    // Check if class has active students
    const students = await databaseService.findByCondition('Students', { 
      classId: id,
      isActive: true 
    });

    if (students.length > 0) {
      throw new AppError('Cannot delete class with active students', 400);
    }

    // Soft delete by setting isActive to false
    await databaseService.update('Classes', id, { 
      isActive: false,
      updatedAt: moment().toISOString()
    });

    res.deleted('Class deactivated successfully');
  });

  // Get students in a class
  getClassStudents = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { page = 1, limit = 20 } = req.query;

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', id);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: {
        classId: id,
        isActive: true
      }
    };

    const result = await databaseService.paginate('Students', options);

    // Get user information for each student
    const studentsWithUserInfo = await Promise.all(
      result.data.map(async (student) => {
        const user = await databaseService.findOne('Users', { username: student.username });
        return {
          ...student,
          userInfo: user ? {
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            phone: user.phone,
            avatarUrl: user.avatarUrl
          } : null
        };
      })
    );

    res.paginated(studentsWithUserInfo, result.pagination, `Students in class "${classEntity.name}" retrieved successfully`);
  });

  // Get class timetable
  getClassTimetable = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', id);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Get timetable from class or return empty structure
    const timetable = classEntity.timetable || {
      monday: [],
      tuesday: [],
      wednesday: [],
      thursday: [],
      friday: [],
      saturday: [],
      sunday: []
    };

    res.success(timetable, 'Class timetable retrieved successfully');
  });

  // Update class timetable
  updateClassTimetable = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { timetable } = req.body;

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', id);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Validate timetable structure
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    
    if (!timetable || typeof timetable !== 'object') {
      throw new AppError('Timetable must be an object', 400);
    }

    for (const day of days) {
      if (timetable[day] && !Array.isArray(timetable[day])) {
        throw new AppError(`Timetable.${day} must be an array`, 400);
      }
    }

    // Update timetable
    const updatedClass = await databaseService.update('Classes', id, { 
      timetable,
      updatedAt: moment().toISOString()
    });

    res.updated(updatedClass, 'Class timetable updated successfully');
  });

  // Get classes by academic year
  getClassesByAcademicYear = catchAsync(async (req, res) => {
    const { academicYear } = req.params;
    const { page = 1, limit = 20 } = req.query;

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: {
        academicYear,
        isActive: true
      }
    };

    const result = await databaseService.paginate('Classes', options);

    // Get teacher information for each class
    const classesWithTeacherInfo = await Promise.all(
      result.data.map(async (classEntity) => {
        let teacherInfo = null;
        if (classEntity.teacherId) {
          const teacher = await databaseService.findById('Teachers', classEntity.teacherId);
          if (teacher) {
            const user = await databaseService.findOne('Users', { username: teacher.username });
            teacherInfo = {
              ...teacher,
              userInfo: user ? {
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email
              } : null
            };
          }
        }

        // Get student count for each class
        const students = await databaseService.findByCondition('Students', { 
          classId: classEntity.id,
          isActive: true 
        });

        return {
          ...classEntity,
          teacherInfo,
          studentCount: students.length
        };
      })
    );

    res.paginated(classesWithTeacherInfo, result.pagination, `Classes for academic year ${academicYear} retrieved successfully`);
  });

  // Get class statistics
  getClassStats = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', id);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    const stats = {};

    // Get student count
    const students = await databaseService.findByCondition('Students', { 
      classId: id,
      isActive: true 
    });
    stats.totalStudents = students.length;

    // Get gender distribution
    const studentUsernames = students.map(student => student.username);
    const users = await Promise.all(
      studentUsernames.map(username => databaseService.findOne('Users', { username }))
    );
    
    const genderCount = {
      male: 0,
      female: 0,
      other: 0,
      notSpecified: 0
    };
    
    users.forEach(user => {
      if (user && user.gender) {
        genderCount[user.gender] += 1;
      } else {
        genderCount.notSpecified += 1;
      }
    });
    
    stats.genderDistribution = genderCount;

    // Get assignment count
    const assignments = await databaseService.findByCondition('Assignments', { classId: id });
    stats.totalAssignments = assignments.length;

    // Get exam count
    const exams = await databaseService.findByCondition('Exams', { classId: id });
    stats.totalExams = exams.length;

    // Get attendance records
    const attendanceRecords = await databaseService.findByCondition('Attendance', { classId: id });
    stats.totalAttendanceRecords = attendanceRecords.length;

    // Get recent attendance percentage (last 30 days)
    const thirtyDaysAgo = moment().subtract(30, 'days').toISOString();
    const recentAttendance = attendanceRecords.filter(record => 
      moment(record.date).isAfter(thirtyDaysAgo)
    );
    
    let attendancePercentage = 0;
    if (recentAttendance.length > 0) {
      const totalEntries = recentAttendance.length * stats.totalStudents;
      const presentEntries = recentAttendance.reduce((sum, record) => 
        sum + (record.presentStudents ? record.presentStudents.length : 0), 0);
      
      attendancePercentage = totalEntries > 0 ? (presentEntries / totalEntries) * 100 : 0;
    }
    
    stats.recentAttendancePercentage = Math.round(attendancePercentage * 100) / 100;

    res.success(stats, 'Class statistics retrieved successfully');
  });

  // Search classes
  searchClasses = catchAsync(async (req, res) => {
    const { query, academicYear, page = 1, limit = 20 } = req.query;

    if (!query) {
      throw new AppError('Search query is required', 400);
    }

    // Get all active classes
    const classes = await databaseService.findByCondition('Classes', { isActive: true });

    // Filter based on search query
    let filteredClasses = classes.filter(classEntity => {
      const searchQuery = query.toLowerCase();
      
      return (
        (classEntity.name && classEntity.name.toLowerCase().includes(searchQuery)) ||
        (classEntity.section && classEntity.section.toLowerCase().includes(searchQuery)) ||
        (classEntity.description && classEntity.description.toLowerCase().includes(searchQuery))
      );
    });

    // Filter by academic year if provided
    if (academicYear) {
      filteredClasses = filteredClasses.filter(classEntity => 
        classEntity.academicYear === academicYear
      );
    }

    // Manual pagination
    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const endIndex = startIndex + parseInt(limit);
    const paginatedClasses = filteredClasses.slice(startIndex, endIndex);

    // Get teacher and student count information
    const classesWithInfo = await Promise.all(
      paginatedClasses.map(async (classEntity) => {
        let teacherInfo = null;
        if (classEntity.teacherId) {
          const teacher = await databaseService.findById('Teachers', classEntity.teacherId);
          if (teacher) {
            const user = await databaseService.findOne('Users', { username: teacher.username });
            teacherInfo = {
              ...teacher,
              userInfo: user ? {
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email
              } : null
            };
          }
        }

        // Get student count
        const students = await databaseService.findByCondition('Students', { 
          classId: classEntity.id,
          isActive: true 
        });

        return {
          ...classEntity,
          teacherInfo,
          studentCount: students.length
        };
      })
    );

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: filteredClasses.length,
      pages: Math.ceil(filteredClasses.length / parseInt(limit)),
      hasNext: endIndex < filteredClasses.length,
      hasPrev: parseInt(page) > 1
    };

    res.paginated(classesWithInfo, pagination, 'Class search results retrieved successfully');
  });
}

module.exports = new ClassController();