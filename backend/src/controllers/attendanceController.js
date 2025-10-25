const databaseService = require('../services/databaseService');
const { catchAsync, AppError } = require('../middleware/errorHandler');
const { validateAttendance, validateAttendanceUpdate } = require('../validators/attendanceValidator');
const moment = require('moment');

class AttendanceController {
  // Get attendance records with pagination
  getAllAttendance = catchAsync(async (req, res) => {
    const {
      page = 1,
      limit = 20,
      classId,
      date,
      startDate,
      endDate,
      sortBy = 'date',
      sortOrder = 'DESC'
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: {}
    };

    // Apply filters
    if (classId) {
      options.where.classId = classId;
    }

    if (date) {
      options.where.date = date;
    } else if (startDate && endDate) {
      options.where.date = {
        $gte: startDate,
        $lte: endDate
      };
    }

    const result = await databaseService.paginate('Attendance', options);

    // Get class information for each attendance record
    const attendanceWithInfo = await Promise.all(
      result.data.map(async (record) => {
        let classInfo = null;
        if (record.classId) {
          const classEntity = await databaseService.findById('Classes', record.classId);
          classInfo = classEntity || null;
        }

        // Calculate attendance percentage
        const totalStudents = record.totalStudents || 0;
        const presentStudents = record.presentStudents ? record.presentStudents.length : 0;
        const attendancePercentage = totalStudents > 0 
          ? Math.round((presentStudents / totalStudents) * 100) 
          : 0;

        return {
          ...record,
          classInfo,
          attendancePercentage
        };
      })
    );

    res.paginated(attendanceWithInfo, result.pagination, 'Attendance records retrieved successfully');
  });

  // Get attendance by ID
  getAttendanceById = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    const attendance = await databaseService.findById('Attendance', id);
    
    if (!attendance) {
      throw new AppError('Attendance record not found', 404);
    }

    // Get class information
    let classInfo = null;
    if (attendance.classId) {
      const classEntity = await databaseService.findById('Classes', attendance.classId);
      classInfo = classEntity || null;
    }

    // Calculate attendance percentage
    const totalStudents = attendance.totalStudents || 0;
    const presentStudents = attendance.presentStudents ? attendance.presentStudents.length : 0;
    const attendancePercentage = totalStudents > 0 
      ? Math.round((presentStudents / totalStudents) * 100) 
      : 0;

    // Get detailed student information for present and absent students
    const presentStudentDetails = [];
    const absentStudentDetails = [];

    if (attendance.presentStudents && attendance.presentStudents.length > 0) {
      for (const studentId of attendance.presentStudents) {
        const student = await databaseService.findById('Students', studentId);
        if (student) {
          const user = await databaseService.findOne('Users', { username: student.username });
          presentStudentDetails.push({
            ...student,
            userInfo: user ? {
              firstName: user.firstName,
              lastName: user.lastName,
              email: user.email,
              avatarUrl: user.avatarUrl
            } : null
          });
        }
      }
    }

    if (attendance.absentStudents && attendance.absentStudents.length > 0) {
      for (const studentId of attendance.absentStudents) {
        const student = await databaseService.findById('Students', studentId);
        if (student) {
          const user = await databaseService.findOne('Users', { username: student.username });
          absentStudentDetails.push({
            ...student,
            userInfo: user ? {
              firstName: user.firstName,
              lastName: user.lastName,
              email: user.email,
              avatarUrl: user.avatarUrl
            } : null
          });
        }
      }
    }

    const attendanceWithDetails = {
      ...attendance,
      classInfo,
      attendancePercentage,
      presentStudentDetails,
      absentStudentDetails
    };

    res.success(attendanceWithDetails, 'Attendance record retrieved successfully');
  });

  // Create new attendance record
  createAttendance = catchAsync(async (req, res) => {
    // Validate input
    const { error, value } = validateAttendance(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', value.classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Check if attendance record for this class and date already exists
    const existingAttendance = await databaseService.findOne('Attendance', {
      classId: value.classId,
      date: value.date
    });

    if (existingAttendance) {
      throw new AppError('Attendance record for this class and date already exists', 409);
    }

    // Get all students in the class
    const students = await databaseService.findByCondition('Students', {
      classId: value.classId,
      isActive: true
    });

    // Validate that all present and absent student IDs exist in the class
    const studentIds = students.map(student => student.id);
    
    if (value.presentStudents) {
      for (const studentId of value.presentStudents) {
        if (!studentIds.includes(studentId)) {
          throw new AppError(`Student with ID ${studentId} is not in this class`, 400);
        }
      }
    }

    if (value.absentStudents) {
      for (const studentId of value.absentStudents) {
        if (!studentIds.includes(studentId)) {
          throw new AppError(`Student with ID ${studentId} is not in this class`, 400);
        }
      }
    }

    // If absentStudents is not provided, calculate it from presentStudents
    let absentStudents = value.absentStudents;
    if (!absentStudents && value.presentStudents) {
      absentStudents = studentIds.filter(id => !value.presentStudents.includes(id));
    }

    // If presentStudents is not provided, calculate it from absentStudents
    let presentStudents = value.presentStudents;
    if (!presentStudents && value.absentStudents) {
      presentStudents = studentIds.filter(id => !value.absentStudents.includes(id));
    }

    // Prepare attendance data
    const attendanceData = {
      ...value,
      presentStudents,
      absentStudents,
      totalStudents: studentIds.length,
      createdAt: moment().toISOString(),
      updatedAt: moment().toISOString()
    };

    // Create attendance record
    const newAttendance = await databaseService.create('Attendance', attendanceData);

    res.created(newAttendance, 'Attendance record created successfully');
  });

  // Update attendance record
  updateAttendance = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    // Validate input
    const { error, value } = validateAttendanceUpdate(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if attendance record exists
    const existingAttendance = await databaseService.findById('Attendance', id);
    if (!existingAttendance) {
      throw new AppError('Attendance record not found', 404);
    }

    // Check if class exists if classId is provided
    if (value.classId) {
      const classEntity = await databaseService.findById('Classes', value.classId);
      if (!classEntity) {
        throw new AppError('Class not found', 404);
      }
    }

    const classId = value.classId || existingAttendance.classId;

    // Check if changing date would create a duplicate
    if (value.date && value.date !== existingAttendance.date) {
      const duplicateAttendance = await databaseService.findOne('Attendance', {
        classId,
        date: value.date
      });

      if (duplicateAttendance && duplicateAttendance.id !== id) {
        throw new AppError('Attendance record for this class and date already exists', 409);
      }
    }

    // Get all students in the class
    const students = await databaseService.findByCondition('Students', {
      classId,
      isActive: true
    });
    const studentIds = students.map(student => student.id);

    // Validate that all present and absent student IDs exist in the class
    if (value.presentStudents) {
      for (const studentId of value.presentStudents) {
        if (!studentIds.includes(studentId)) {
          throw new AppError(`Student with ID ${studentId} is not in this class`, 400);
        }
      }
    }

    if (value.absentStudents) {
      for (const studentId of value.absentStudents) {
        if (!studentIds.includes(studentId)) {
          throw new AppError(`Student with ID ${studentId} is not in this class`, 400);
        }
      }
    }

    // Calculate present/absent students if only one is provided
    let updateData = { ...value };
    
    if (value.presentStudents && !value.absentStudents) {
      updateData.absentStudents = studentIds.filter(id => !value.presentStudents.includes(id));
    } else if (value.absentStudents && !value.presentStudents) {
      updateData.presentStudents = studentIds.filter(id => !value.absentStudents.includes(id));
    }

    // Update total students count if class has changed
    if (value.classId && value.classId !== existingAttendance.classId) {
      updateData.totalStudents = studentIds.length;
    }

    // Add timestamp
    updateData.updatedAt = moment().toISOString();

    // Update attendance record
    const updatedAttendance = await databaseService.update('Attendance', id, updateData);

    res.updated(updatedAttendance, 'Attendance record updated successfully');
  });

  // Delete attendance record
  deleteAttendance = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if attendance record exists
    const existingAttendance = await databaseService.findById('Attendance', id);
    if (!existingAttendance) {
      throw new AppError('Attendance record not found', 404);
    }

    // Delete attendance record
    await databaseService.delete('Attendance', id);

    res.deleted('Attendance record deleted successfully');
  });

  // Get attendance records for a specific class
  getClassAttendance = catchAsync(async (req, res) => {
    const { classId } = req.params;
    const { page = 1, limit = 20, startDate, endDate } = req.query;

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: { classId }
    };

    // Filter by date range if provided
    if (startDate && endDate) {
      options.where.date = {
        $gte: startDate,
        $lte: endDate
      };
    }

    const result = await databaseService.paginate('Attendance', options);

    // Calculate attendance percentage for each record
    const attendanceWithPercentage = result.data.map(record => {
      const totalStudents = record.totalStudents || 0;
      const presentStudents = record.presentStudents ? record.presentStudents.length : 0;
      const attendancePercentage = totalStudents > 0 
        ? Math.round((presentStudents / totalStudents) * 100) 
        : 0;

      return {
        ...record,
        attendancePercentage,
        classInfo: {
          name: classEntity.name,
          section: classEntity.section,
          grade: classEntity.grade
        }
      };
    });

    res.paginated(attendanceWithPercentage, result.pagination, `Attendance records for class "${classEntity.name}" retrieved successfully`);
  });

  // Get attendance record for a specific student
  getStudentAttendance = catchAsync(async (req, res) => {
    const { studentId } = req.params;
    const { page = 1, limit = 20, startDate, endDate } = req.query;

    // Check if student exists
    const student = await databaseService.findById('Students', studentId);
    if (!student) {
      throw new AppError('Student not found', 404);
    }

    // Get user information
    const user = await databaseService.findOne('Users', { username: student.username });
    if (!user) {
      throw new AppError('User not found', 404);
    }

    // Get class information
    const classEntity = await databaseService.findById('Classes', student.classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Get all attendance records for the student's class
    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: { classId: student.classId }
    };

    // Filter by date range if provided
    if (startDate && endDate) {
      options.where.date = {
        $gte: startDate,
        $lte: endDate
      };
    }

    const result = await databaseService.paginate('Attendance', options);

    // Filter attendance records for this student
    const studentAttendance = result.data.map(record => {
      const isPresent = record.presentStudents && record.presentStudents.includes(studentId);
      
      return {
        id: record.id,
        date: record.date,
        status: isPresent ? 'present' : 'absent',
        notes: record.notes,
        subject: record.subject,
        classInfo: {
          id: classEntity.id,
          name: classEntity.name,
          section: classEntity.section,
          grade: classEntity.grade
        }
      };
    });

    // Calculate attendance statistics
    const totalRecords = studentAttendance.length;
    const presentCount = studentAttendance.filter(record => record.status === 'present').length;
    const absentCount = totalRecords - presentCount;
    const attendancePercentage = totalRecords > 0 
      ? Math.round((presentCount / totalRecords) * 100) 
      : 0;

    const statistics = {
      totalDays: totalRecords,
      presentDays: presentCount,
      absentDays: absentCount,
      attendancePercentage
    };

    const response = {
      studentInfo: {
        id: studentId,
        rollNumber: student.rollNumber,
        userInfo: {
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          avatarUrl: user.avatarUrl
        },
        classInfo: {
          id: classEntity.id,
          name: classEntity.name,
          section: classEntity.section,
          grade: classEntity.grade
        }
      },
      statistics,
      attendance: studentAttendance
    };

    const pagination = {
      ...result.pagination,
      total: totalRecords
    };

    res.paginated(response, pagination, `Attendance records for student ${user.firstName} ${user.lastName} retrieved successfully`);
  });

  // Get attendance statistics for a class
  getClassAttendanceStats = catchAsync(async (req, res) => {
    const { classId } = req.params;
    const { startDate, endDate } = req.query;

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Get all students in the class
    const students = await databaseService.findByCondition('Students', {
      classId,
      isActive: true
    });

    // Get attendance records for the class
    const where = { classId };
    
    // Filter by date range if provided
    if (startDate && endDate) {
      where.date = {
        $gte: startDate,
        $lte: endDate
      };
    }

    const attendanceRecords = await databaseService.findByCondition('Attendance', where);

    // Calculate overall attendance percentage
    const totalPossibleAttendances = attendanceRecords.length * students.length;
    let totalPresent = 0;

    attendanceRecords.forEach(record => {
      if (record.presentStudents) {
        totalPresent += record.presentStudents.length;
      }
    });

    const overallAttendancePercentage = totalPossibleAttendances > 0 
      ? Math.round((totalPresent / totalPossibleAttendances) * 100) 
      : 0;

    // Calculate attendance percentage by day
    const attendanceByDate = {};
    attendanceRecords.forEach(record => {
      const presentCount = record.presentStudents ? record.presentStudents.length : 0;
      const totalCount = record.totalStudents || students.length;
      const percentage = totalCount > 0 ? Math.round((presentCount / totalCount) * 100) : 0;
      
      attendanceByDate[record.date] = {
        date: record.date,
        present: presentCount,
        absent: totalCount - presentCount,
        total: totalCount,
        percentage
      };
    });

    // Calculate attendance percentage by student
    const attendanceByStudent = {};
    
    for (const student of students) {
      let presentCount = 0;
      
      attendanceRecords.forEach(record => {
        if (record.presentStudents && record.presentStudents.includes(student.id)) {
          presentCount++;
        }
      });
      
      const percentage = attendanceRecords.length > 0 
        ? Math.round((presentCount / attendanceRecords.length) * 100) 
        : 0;
      
      // Get user information
      const user = await databaseService.findOne('Users', { username: student.username });
      
      attendanceByStudent[student.id] = {
        studentId: student.id,
        rollNumber: student.rollNumber,
        userInfo: user ? {
          firstName: user.firstName,
          lastName: user.lastName
        } : null,
        present: presentCount,
        absent: attendanceRecords.length - presentCount,
        total: attendanceRecords.length,
        percentage
      };
    }

    const stats = {
      classInfo: {
        id: classEntity.id,
        name: classEntity.name,
        section: classEntity.section,
        grade: classEntity.grade
      },
      dateRange: {
        startDate: startDate || (attendanceRecords.length > 0 ? attendanceRecords[0].date : null),
        endDate: endDate || (attendanceRecords.length > 0 ? attendanceRecords[attendanceRecords.length - 1].date : null)
      },
      summary: {
        totalDays: attendanceRecords.length,
        totalStudents: students.length,
        overallAttendancePercentage,
        totalPresent,
        totalAbsent: totalPossibleAttendances - totalPresent
      },
      attendanceByDate: Object.values(attendanceByDate),
      attendanceByStudent: Object.values(attendanceByStudent)
    };

    res.success(stats, `Attendance statistics for class "${classEntity.name}" retrieved successfully`);
  });

  // Mark attendance for a class
  markAttendance = catchAsync(async (req, res) => {
    const { classId } = req.params;
    const { date, subject, presentStudents, absentStudents, notes } = req.body;

    // Validate required fields
    if (!date) {
      throw new AppError('Date is required', 400);
    }

    if (!presentStudents && !absentStudents) {
      throw new AppError('Either present or absent students must be provided', 400);
    }

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Check if attendance record for this class and date already exists
    const existingAttendance = await databaseService.findOne('Attendance', {
      classId,
      date
    });

    // If record exists, update it
    if (existingAttendance) {
      // Get all students in the class
      const students = await databaseService.findByCondition('Students', {
        classId,
        isActive: true
      });
      const studentIds = students.map(student => student.id);

      // Calculate present/absent students if only one is provided
      let updateData = { 
        subject,
        notes,
        updatedAt: moment().toISOString()
      };
      
      if (presentStudents) {
        // Validate that all present student IDs exist in the class
        for (const studentId of presentStudents) {
          if (!studentIds.includes(studentId)) {
            throw new AppError(`Student with ID ${studentId} is not in this class`, 400);
          }
        }
        
        updateData.presentStudents = presentStudents;
        updateData.absentStudents = studentIds.filter(id => !presentStudents.includes(id));
      } else if (absentStudents) {
        // Validate that all absent student IDs exist in the class
        for (const studentId of absentStudents) {
          if (!studentIds.includes(studentId)) {
            throw new AppError(`Student with ID ${studentId} is not in this class`, 400);
          }
        }
        
        updateData.absentStudents = absentStudents;
        updateData.presentStudents = studentIds.filter(id => !absentStudents.includes(id));
      }

      // Update attendance record
      const updatedAttendance = await databaseService.update('Attendance', existingAttendance.id, updateData);

      res.updated(updatedAttendance, 'Attendance record updated successfully');
    } else {
      // Create new attendance record
      // Get all students in the class
      const students = await databaseService.findByCondition('Students', {
        classId,
        isActive: true
      });
      const studentIds = students.map(student => student.id);

      // Calculate present/absent students if only one is provided
      let attendanceData = {
        classId,
        date,
        subject,
        notes,
        totalStudents: studentIds.length,
        createdAt: moment().toISOString(),
        updatedAt: moment().toISOString()
      };
      
      if (presentStudents) {
        // Validate that all present student IDs exist in the class
        for (const studentId of presentStudents) {
          if (!studentIds.includes(studentId)) {
            throw new AppError(`Student with ID ${studentId} is not in this class`, 400);
          }
        }
        
        attendanceData.presentStudents = presentStudents;
        attendanceData.absentStudents = studentIds.filter(id => !presentStudents.includes(id));
      } else if (absentStudents) {
        // Validate that all absent student IDs exist in the class
        for (const studentId of absentStudents) {
          if (!studentIds.includes(studentId)) {
            throw new AppError(`Student with ID ${studentId} is not in this class`, 400);
          }
        }
        
        attendanceData.absentStudents = absentStudents;
        attendanceData.presentStudents = studentIds.filter(id => !absentStudents.includes(id));
      }

      // Create attendance record
      const newAttendance = await databaseService.create('Attendance', attendanceData);

      res.created(newAttendance, 'Attendance record created successfully');
    }
  });
}

module.exports = new AttendanceController();