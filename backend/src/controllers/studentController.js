const databaseService = require('../services/databaseService');
const { catchAsync, AppError } = require('../middleware/errorHandler');
const { validateStudent, validateStudentUpdate } = require('../validators/studentValidator');
const moment = require('moment');

class StudentController {
  // Get all students with pagination
  getAllStudents = catchAsync(async (req, res) => {
    const {
      page = 1,
      limit = 20,
      classId,
      isActive = true,
      sortBy = 'createdAt',
      sortOrder = 'DESC'
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: { isActive: isActive === 'true' }
    };

    // Filter by class if provided
    if (classId) {
      options.where.classId = classId;
    }

    const result = await databaseService.paginate('Students', options);

    // Get associated user information for each student
    const studentsWithUserInfo = await Promise.all(
      result.data.map(async (student) => {
        const user = await databaseService.findOne('Users', { username: student.username });
        
        // Get class information
        let classInfo = null;
        if (student.classId) {
          classInfo = await databaseService.findById('Classes', student.classId);
        }
        
        // Get parent information
        let parentInfo = null;
        if (student.parentId) {
          parentInfo = await databaseService.findById('Parents', student.parentId);
          
          if (parentInfo) {
            const parentUser = await databaseService.findOne('Users', { username: parentInfo.username });
            parentInfo = {
              ...parentInfo,
              userInfo: parentUser ? {
                firstName: parentUser.firstName,
                lastName: parentUser.lastName,
                email: parentUser.email,
                phone: parentUser.phone
              } : null
            };
          }
        }
        
        return {
          ...student,
          userInfo: user ? {
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            phone: user.phone,
            avatarUrl: user.avatarUrl
          } : null,
          classInfo: classInfo ? {
            name: classInfo.name,
            section: classInfo.section,
            academicYear: classInfo.academicYear
          } : null,
          parentInfo
        };
      })
    );

    res.paginated(studentsWithUserInfo, result.pagination, 'Students retrieved successfully');
  });

  // Get student by ID
  getStudentById = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    const student = await databaseService.findById('Students', id);
    
    if (!student) {
      throw new AppError('Student not found', 404);
    }

    // Get associated user information
    const user = await databaseService.findOne('Users', { username: student.username });
    
    // Get class information
    let classInfo = null;
    if (student.classId) {
      classInfo = await databaseService.findById('Classes', student.classId);
    }
    
    // Get parent information
    let parentInfo = null;
    if (student.parentId) {
      parentInfo = await databaseService.findById('Parents', student.parentId);
      
      if (parentInfo) {
        const parentUser = await databaseService.findOne('Users', { username: parentInfo.username });
        parentInfo = {
          ...parentInfo,
          userInfo: parentUser ? {
            firstName: parentUser.firstName,
            lastName: parentUser.lastName,
            email: parentUser.email,
            phone: parentUser.phone
          } : null
        };
      }
    }
    
    const studentWithInfo = {
      ...student,
      userInfo: user,
      classInfo,
      parentInfo
    };

    res.success(studentWithInfo, 'Student retrieved successfully');
  });

  // Create new student
  createStudent = catchAsync(async (req, res) => {
    // Validate input
    const { error, value } = validateStudent(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if user exists and is a student
    const user = await databaseService.findOne('Users', { username: value.username });
    if (!user) {
      throw new AppError('User not found. Please create user account first.', 404);
    }

    if (user.userType !== 'student') {
      throw new AppError('User must be of type "student"', 400);
    }

    // Check if student profile already exists
    const existingStudent = await databaseService.findOne('Students', { username: value.username });
    if (existingStudent) {
      throw new AppError('Student profile already exists', 409);
    }

    // Check if class exists if provided
    if (value.classId) {
      const classEntity = await databaseService.findById('Classes', value.classId);
      if (!classEntity) {
        throw new AppError('Class not found', 404);
      }
    }

    // Check if parent exists if provided
    if (value.parentId) {
      const parent = await databaseService.findById('Parents', value.parentId);
      if (!parent) {
        throw new AppError('Parent not found', 404);
      }
    }

    // Prepare student data
    const studentData = {
      ...value,
      isActive: true
    };

    // Create student
    const student = await databaseService.create('Students', studentData);

    // Get user info for response
    const studentWithUserInfo = {
      ...student,
      userInfo: user
    };

    res.created(studentWithUserInfo, 'Student created successfully');
  });

  // Update student
  updateStudent = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    // Validate input
    const { error, value } = validateStudentUpdate(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if student exists
    const existingStudent = await databaseService.findById('Students', id);
    if (!existingStudent) {
      throw new AppError('Student not found', 404);
    }

    // Check if class exists if provided
    if (value.classId) {
      const classEntity = await databaseService.findById('Classes', value.classId);
      if (!classEntity) {
        throw new AppError('Class not found', 404);
      }
    }

    // Check if parent exists if provided
    if (value.parentId) {
      const parent = await databaseService.findById('Parents', value.parentId);
      if (!parent) {
        throw new AppError('Parent not found', 404);
      }
    }

    // Update student
    const updatedStudent = await databaseService.update('Students', id, value);

    // Get associated user information
    const user = await databaseService.findOne('Users', { username: updatedStudent.username });
    
    const studentWithUserInfo = {
      ...updatedStudent,
      userInfo: user
    };

    res.updated(studentWithUserInfo, 'Student updated successfully');
  });

  // Delete student (soft delete)
  deleteStudent = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if student exists
    const existingStudent = await databaseService.findById('Students', id);
    if (!existingStudent) {
      throw new AppError('Student not found', 404);
    }

    // Soft delete by setting isActive to false
    await databaseService.update('Students', id, { isActive: false });

    res.deleted('Student deactivated successfully');
  });

  // Get students by class
  getStudentsByClass = catchAsync(async (req, res) => {
    const { classId } = req.params;
    const { page = 1, limit = 20 } = req.query;

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: {
        classId,
        isActive: true
      }
    };

    const result = await databaseService.paginate('Students', options);

    // Get associated user information for each student
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

    res.paginated(studentsWithUserInfo, result.pagination, `Students for class "${classEntity.name}" retrieved successfully`);
  });

  // Get student's attendance
  getStudentAttendance = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { startDate, endDate, page = 1, limit = 20 } = req.query;

    // Check if student exists
    const student = await databaseService.findById('Students', id);
    if (!student) {
      throw new AppError('Student not found', 404);
    }

    // Get all attendance records for this student
    let attendanceRecords = await databaseService.findByCondition('Attendance', { studentId: id });

    // Filter by date range if provided
    if (startDate && endDate) {
      attendanceRecords = attendanceRecords.filter(record => 
        moment(record.date).isBetween(moment(startDate), moment(endDate), null, '[]')
      );
    }

    // Sort by date (newest first)
    attendanceRecords.sort((a, b) => new Date(b.date) - new Date(a.date));

    // Manual pagination
    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const endIndex = startIndex + parseInt(limit);
    const paginatedRecords = attendanceRecords.slice(startIndex, endIndex);

    // Get class information for each attendance record
    const attendanceWithClassInfo = await Promise.all(
      paginatedRecords.map(async (record) => {
        const classEntity = await databaseService.findById('Classes', record.classId);
        return {
          ...record,
          classInfo: classEntity ? {
            name: classEntity.name,
            section: classEntity.section
          } : null
        };
      })
    );

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: attendanceRecords.length,
      pages: Math.ceil(attendanceRecords.length / parseInt(limit)),
      hasNext: endIndex < attendanceRecords.length,
      hasPrev: parseInt(page) > 1
    };

    res.paginated(attendanceWithClassInfo, pagination, 'Student attendance records retrieved successfully');
  });

  // Get student's assignments
  getStudentAssignments = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { status, page = 1, limit = 20 } = req.query;

    // Check if student exists
    const student = await databaseService.findById('Students', id);
    if (!student) {
      throw new AppError('Student not found', 404);
    }

    // Get all assignments for this student's class
    const assignments = await databaseService.findByCondition('Assignments', { 
      classId: student.classId
    });

    // Filter by status if provided
    let filteredAssignments = assignments;
    if (status) {
      if (status === 'pending') {
        filteredAssignments = assignments.filter(assignment => {
          // Check if student has submitted this assignment
          const submission = assignment.submissions?.find(sub => sub.studentId === id);
          return !submission && moment(assignment.dueDate).isAfter(moment());
        });
      } else if (status === 'submitted') {
        filteredAssignments = assignments.filter(assignment => {
          // Check if student has submitted this assignment
          const submission = assignment.submissions?.find(sub => sub.studentId === id);
          return submission !== undefined;
        });
      } else if (status === 'overdue') {
        filteredAssignments = assignments.filter(assignment => {
          // Check if student has not submitted and due date has passed
          const submission = assignment.submissions?.find(sub => sub.studentId === id);
          return !submission && moment(assignment.dueDate).isBefore(moment());
        });
      }
    }

    // Sort by due date (closest first)
    filteredAssignments.sort((a, b) => new Date(a.dueDate) - new Date(b.dueDate));

    // Manual pagination
    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const endIndex = startIndex + parseInt(limit);
    const paginatedAssignments = filteredAssignments.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: filteredAssignments.length,
      pages: Math.ceil(filteredAssignments.length / parseInt(limit)),
      hasNext: endIndex < filteredAssignments.length,
      hasPrev: parseInt(page) > 1
    };

    res.paginated(paginatedAssignments, pagination, 'Student assignments retrieved successfully');
  });

  // Get student's exam results
  getStudentExams = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { page = 1, limit = 20 } = req.query;

    // Check if student exists
    const student = await databaseService.findById('Students', id);
    if (!student) {
      throw new AppError('Student not found', 404);
    }

    // Get all exams for this student's class
    const exams = await databaseService.findByCondition('Exams', { 
      classId: student.classId
    });

    // Filter to include only exams with results for this student
    const examsWithResults = exams.filter(exam => {
      return exam.results && exam.results.some(result => result.studentId === id);
    });

    // Sort by date (newest first)
    examsWithResults.sort((a, b) => new Date(b.date) - new Date(a.date));

    // Manual pagination
    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const endIndex = startIndex + parseInt(limit);
    const paginatedExams = examsWithResults.slice(startIndex, endIndex);

    // Filter results to only show this student's results
    const examsWithStudentResults = paginatedExams.map(exam => {
      const studentResult = exam.results.find(result => result.studentId === id);
      return {
        ...exam,
        results: studentResult ? [studentResult] : []
      };
    });

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: examsWithResults.length,
      pages: Math.ceil(examsWithResults.length / parseInt(limit)),
      hasNext: endIndex < examsWithResults.length,
      hasPrev: parseInt(page) > 1
    };

    res.paginated(examsWithStudentResults, pagination, 'Student exam results retrieved successfully');
  });

  // Get student's timetable
  getStudentTimetable = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if student exists
    const student = await databaseService.findById('Students', id);
    if (!student) {
      throw new AppError('Student not found', 404);
    }

    // Check if class exists
    if (!student.classId) {
      throw new AppError('Student is not assigned to any class', 400);
    }

    const classEntity = await databaseService.findById('Classes', student.classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Get timetable from class
    const timetable = classEntity.timetable || {
      monday: [],
      tuesday: [],
      wednesday: [],
      thursday: [],
      friday: [],
      saturday: [],
      sunday: []
    };

    res.success(timetable, 'Student timetable retrieved successfully');
  });

  // Get student dashboard data
  getStudentDashboard = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if student exists
    const student = await databaseService.findById('Students', id);
    if (!student) {
      throw new AppError('Student not found', 404);
    }

    // Get user info
    const user = await databaseService.findOne('Users', { username: student.username });

    // Get class info
    let classInfo = null;
    if (student.classId) {
      classInfo = await databaseService.findById('Classes', student.classId);
    }

    const dashboard = {};

    // Basic student info
    dashboard.student = {
      ...student,
      userInfo: user
    };

    // Class info
    dashboard.class = classInfo;

    // Get today's timetable
    const dayOfWeek = moment().format('dddd').toLowerCase();
    dashboard.todayTimetable = classInfo && classInfo.timetable ? classInfo.timetable[dayOfWeek] : [];

    // Get pending assignments
    const assignments = await databaseService.findByCondition('Assignments', { 
      classId: student.classId
    });
    
    // Filter to pending assignments
    const pendingAssignments = assignments.filter(assignment => {
      const submission = assignment.submissions?.find(sub => sub.studentId === id);
      return !submission && moment(assignment.dueDate).isAfter(moment());
    });
    
    // Sort by due date (closest first)
    pendingAssignments.sort((a, b) => new Date(a.dueDate) - new Date(b.dueDate));
    dashboard.pendingAssignments = pendingAssignments.slice(0, 5);

    // Get recent attendance
    const attendanceRecords = await databaseService.findByCondition('Attendance', { studentId: id });
    dashboard.recentAttendance = attendanceRecords
      .sort((a, b) => new Date(b.date) - new Date(a.date))
      .slice(0, 5);

    // Get upcoming exams
    const upcomingExams = await databaseService.findByCondition('Exams', { 
      classId: student.classId
    });
    dashboard.upcomingExams = upcomingExams
      .filter(exam => moment(exam.date).isAfter(moment()))
      .sort((a, b) => new Date(a.date) - new Date(b.date))
      .slice(0, 5);

    // Get recent notifications
    const notifications = await databaseService.findByCondition('Notifications', { 
      'recipients.specificUsers': id
    });
    dashboard.recentNotifications = notifications
      .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
      .slice(0, 5);

    res.success(dashboard, 'Student dashboard data retrieved successfully');
  });

  // Search students
  searchStudents = catchAsync(async (req, res) => {
    const { query, classId, page = 1, limit = 20 } = req.query;

    if (!query) {
      throw new AppError('Search query is required', 400);
    }

    // Get all active students
    const students = await databaseService.findByCondition('Students', { isActive: true });

    // Get user information for each student for searching
    const studentsWithUsers = await Promise.all(
      students.map(async (student) => {
        const user = await databaseService.findOne('Users', { username: student.username });
        return {
          ...student,
          userInfo: user
        };
      })
    );

    // Filter based on search query
    let filteredStudents = studentsWithUsers.filter(student => {
      const userInfo = student.userInfo;
      const searchQuery = query.toLowerCase();
      
      return (
        (userInfo && userInfo.firstName && userInfo.firstName.toLowerCase().includes(searchQuery)) ||
        (userInfo && userInfo.lastName && userInfo.lastName.toLowerCase().includes(searchQuery)) ||
        (userInfo && userInfo.email && userInfo.email.toLowerCase().includes(searchQuery)) ||
        (student.studentId && student.studentId.toLowerCase().includes(searchQuery)) ||
        (student.rollNumber && student.rollNumber.toLowerCase().includes(searchQuery))
      );
    });

    // Filter by class if provided
    if (classId) {
      filteredStudents = filteredStudents.filter(student => student.classId === classId);
    }

    // Manual pagination
    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const endIndex = startIndex + parseInt(limit);
    const paginatedStudents = filteredStudents.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: filteredStudents.length,
      pages: Math.ceil(filteredStudents.length / parseInt(limit)),
      hasNext: endIndex < filteredStudents.length,
      hasPrev: parseInt(page) > 1
    };

    res.paginated(paginatedStudents, pagination, 'Student search results retrieved successfully');
  });
}

module.exports = new StudentController();