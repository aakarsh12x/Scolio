const databaseService = require('../services/databaseService');
const { catchAsync, AppError } = require('../middleware/errorHandler');
const { validateTeacher, validateTeacherUpdate } = require('../validators/teacherValidator');
const moment = require('moment');

class TeacherController {
  // Get all teachers with pagination
  getAllTeachers = catchAsync(async (req, res) => {
    const {
      page = 1,
      limit = 20,
      subject,
      isActive = true,
      sortBy = 'createdAt',
      sortOrder = 'DESC'
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: { isActive: isActive === 'true' }
    };

    // Filter by subject if provided
    if (subject) {
      options.where.subjects = { contains: subject };
    }

    const result = await databaseService.paginate('Teachers', options);

    // Get associated user information for each teacher
    const teachersWithUserInfo = await Promise.all(
      result.data.map(async (teacher) => {
        const user = await databaseService.findOne('Users', { username: teacher.username });
        return {
          ...teacher,
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

    res.paginated(teachersWithUserInfo, result.pagination, 'Teachers retrieved successfully');
  });

  // Get teacher by ID
  getTeacherById = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    const teacher = await databaseService.findById('Teachers', id);
    
    if (!teacher) {
      throw new AppError('Teacher not found', 404);
    }

    // Get associated user information
    const user = await databaseService.findOne('Users', { username: teacher.username });
    
    const teacherWithUserInfo = {
      ...teacher,
      userInfo: user
    };

    res.success(teacherWithUserInfo, 'Teacher retrieved successfully');
  });

  // Create new teacher
  createTeacher = catchAsync(async (req, res) => {
    // Validate input
    const { error, value } = validateTeacher(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if user exists and is a teacher
    const user = await databaseService.findOne('Users', { username: value.username });
    if (!user) {
      throw new AppError('User not found. Please create user account first.', 404);
    }

    if (user.userType !== 'teacher') {
      throw new AppError('User must be of type "teacher"', 400);
    }

    // Check if teacher profile already exists
    const existingTeacher = await databaseService.findOne('Teachers', { username: value.username });
    if (existingTeacher) {
      throw new AppError('Teacher profile already exists', 409);
    }

    // Prepare teacher data
    const teacherData = {
      ...value,
      isActive: true
    };

    // Create teacher
    const teacher = await databaseService.create('Teachers', teacherData);

    // Get user info for response
    const teacherWithUserInfo = {
      ...teacher,
      userInfo: user
    };

    res.created(teacherWithUserInfo, 'Teacher created successfully');
  });

  // Update teacher
  updateTeacher = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    // Validate input
    const { error, value } = validateTeacherUpdate(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if teacher exists
    const existingTeacher = await databaseService.findById('Teachers', id);
    if (!existingTeacher) {
      throw new AppError('Teacher not found', 404);
    }

    // Update teacher
    const updatedTeacher = await databaseService.update('Teachers', id, value);

    // Get associated user information
    const user = await databaseService.findOne('Users', { username: updatedTeacher.username });
    
    const teacherWithUserInfo = {
      ...updatedTeacher,
      userInfo: user
    };

    res.updated(teacherWithUserInfo, 'Teacher updated successfully');
  });

  // Delete teacher (soft delete)
  deleteTeacher = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if teacher exists
    const existingTeacher = await databaseService.findById('Teachers', id);
    if (!existingTeacher) {
      throw new AppError('Teacher not found', 404);
    }

    // Soft delete by setting isActive to false
    await databaseService.update('Teachers', id, { isActive: false });

    res.deleted('Teacher deactivated successfully');
  });

  // Get teachers by subject
  getTeachersBySubject = catchAsync(async (req, res) => {
    const { subject } = req.params;
    const { page = 1, limit = 20 } = req.query;

    // Get all active teachers
    const teachers = await databaseService.findByCondition('Teachers', { isActive: true });
    
    // Filter by subject
    const filteredTeachers = teachers.filter(teacher => 
      teacher.subjects && teacher.subjects.includes(subject)
    );

    // Manual pagination
    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const endIndex = startIndex + parseInt(limit);
    const paginatedTeachers = filteredTeachers.slice(startIndex, endIndex);

    // Get user info for each teacher
    const teachersWithUserInfo = await Promise.all(
      paginatedTeachers.map(async (teacher) => {
        const user = await databaseService.findOne('Users', { username: teacher.username });
        return {
          ...teacher,
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

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: filteredTeachers.length,
      pages: Math.ceil(filteredTeachers.length / parseInt(limit)),
      hasNext: endIndex < filteredTeachers.length,
      hasPrev: parseInt(page) > 1
    };

    res.paginated(teachersWithUserInfo, pagination, `Teachers for subject "${subject}" retrieved successfully`);
  });

  // Get teacher's classes
  getTeacherClasses = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { page = 1, limit = 20 } = req.query;

    // Check if teacher exists
    const teacher = await databaseService.findById('Teachers', id);
    if (!teacher) {
      throw new AppError('Teacher not found', 404);
    }

    // Get classes where teacher is assigned
    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: { teacherId: id, isActive: true }
    };

    const result = await databaseService.paginate('Classes', options);

    res.paginated(result.data, result.pagination, 'Teacher classes retrieved successfully');
  });

  // Assign teacher to class
  assignToClass = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { classId } = req.body;

    if (!classId) {
      throw new AppError('Class ID is required', 400);
    }

    // Check if teacher exists
    const teacher = await databaseService.findById('Teachers', id);
    if (!teacher) {
      throw new AppError('Teacher not found', 404);
    }

    // Check if class exists
    const classEntity = await databaseService.findById('Classes', classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    // Update class with teacher assignment
    await databaseService.update('Classes', classId, { 
      teacherId: id,
      updatedAt: moment().toISOString()
    });

    res.success(null, 'Teacher assigned to class successfully');
  });

  // Remove teacher from class
  removeFromClass = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { classId } = req.body;

    if (!classId) {
      throw new AppError('Class ID is required', 400);
    }

    // Check if teacher exists
    const teacher = await databaseService.findById('Teachers', id);
    if (!teacher) {
      throw new AppError('Teacher not found', 404);
    }

    // Check if class exists and is assigned to this teacher
    const classEntity = await databaseService.findById('Classes', classId);
    if (!classEntity) {
      throw new AppError('Class not found', 404);
    }

    if (classEntity.teacherId !== id) {
      throw new AppError('Teacher is not assigned to this class', 400);
    }

    // Remove teacher assignment from class
    await databaseService.update('Classes', classId, { 
      teacherId: null,
      updatedAt: moment().toISOString()
    });

    res.success(null, 'Teacher removed from class successfully');
  });

  // Get teacher statistics
  getTeacherStats = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if teacher exists
    const teacher = await databaseService.findById('Teachers', id);
    if (!teacher) {
      throw new AppError('Teacher not found', 404);
    }

    const stats = {};

    // Get assigned classes count
    const classes = await databaseService.findByCondition('Classes', { teacherId: id, isActive: true });
    stats.totalClasses = classes.length;

    // Get total students across all classes
    let totalStudents = 0;
    for (const classEntity of classes) {
      const students = await databaseService.findByCondition('Students', { classId: classEntity.classId, isActive: true });
      totalStudents += students.length;
    }
    stats.totalStudents = totalStudents;

    // Get assignments created count
    const assignments = await databaseService.findByCondition('Assignments', { teacherId: id });
    stats.totalAssignments = assignments.length;

    // Get recent assignments (last 30 days)
    const thirtyDaysAgo = moment().subtract(30, 'days').toISOString();
    const recentAssignments = assignments.filter(assignment => 
      moment(assignment.createdAt).isAfter(thirtyDaysAgo)
    );
    stats.recentAssignments = recentAssignments.length;

    // Get attendance records taken
    const attendanceRecords = await databaseService.findByCondition('Attendance', { teacherId: id });
    stats.attendanceRecordsTaken = attendanceRecords.length;

    res.success(stats, 'Teacher statistics retrieved successfully');
  });

  // Get teacher dashboard data
  getTeacherDashboard = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if teacher exists
    const teacher = await databaseService.findById('Teachers', id);
    if (!teacher) {
      throw new AppError('Teacher not found', 404);
    }

    // Get user info
    const user = await databaseService.findOne('Users', { username: teacher.username });

    const dashboard = {};

    // Basic teacher info
    dashboard.teacher = {
      ...teacher,
      userInfo: user
    };

    // Get today's classes
    const classes = await databaseService.findByCondition('Classes', { teacherId: id, isActive: true });
    dashboard.todayClasses = classes.slice(0, 5); // Limit to 5 for dashboard

    // Get recent assignments
    const assignments = await databaseService.findByCondition('Assignments', { teacherId: id });
    dashboard.recentAssignments = assignments
      .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
      .slice(0, 5);

    // Get pending assignments (due soon)
    const threeDaysFromNow = moment().add(3, 'days').toISOString();
    const pendingAssignments = assignments.filter(assignment => 
      moment(assignment.dueDate).isBefore(threeDaysFromNow) && 
      moment(assignment.dueDate).isAfter(moment())
    );
    dashboard.pendingAssignments = pendingAssignments.slice(0, 5);

    // Get recent notifications
    const notifications = await databaseService.findByCondition('Notifications', { 
      sender: teacher.username
    });
    dashboard.recentNotifications = notifications
      .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
      .slice(0, 5);

    res.success(dashboard, 'Teacher dashboard data retrieved successfully');
  });

  // Update teacher subjects
  updateSubjects = catchAsync(async (req, res) => {
    const { id } = req.params;
    const { subjects } = req.body;

    if (!subjects || !Array.isArray(subjects)) {
      throw new AppError('Subjects must be an array', 400);
    }

    // Check if teacher exists
    const existingTeacher = await databaseService.findById('Teachers', id);
    if (!existingTeacher) {
      throw new AppError('Teacher not found', 404);
    }

    // Update teacher subjects
    const updatedTeacher = await databaseService.update('Teachers', id, { subjects });

    res.updated(updatedTeacher, 'Teacher subjects updated successfully');
  });

  // Search teachers
  searchTeachers = catchAsync(async (req, res) => {
    const { query, subject, page = 1, limit = 20 } = req.query;

    if (!query) {
      throw new AppError('Search query is required', 400);
    }

    // Get all active teachers
    const teachers = await databaseService.findByCondition('Teachers', { isActive: true });

    // Get user information for each teacher for searching
    const teachersWithUsers = await Promise.all(
      teachers.map(async (teacher) => {
        const user = await databaseService.findOne('Users', { username: teacher.username });
        return {
          ...teacher,
          userInfo: user
        };
      })
    );

    // Filter based on search query
    let filteredTeachers = teachersWithUsers.filter(teacher => {
      const userInfo = teacher.userInfo;
      const searchQuery = query.toLowerCase();
      
      return (
        (userInfo && userInfo.firstName && userInfo.firstName.toLowerCase().includes(searchQuery)) ||
        (userInfo && userInfo.lastName && userInfo.lastName.toLowerCase().includes(searchQuery)) ||
        (userInfo && userInfo.email && userInfo.email.toLowerCase().includes(searchQuery)) ||
        (teacher.employeeId && teacher.employeeId.toLowerCase().includes(searchQuery)) ||
        (teacher.subjects && teacher.subjects.some(sub => sub.toLowerCase().includes(searchQuery)))
      );
    });

    // Filter by subject if provided
    if (subject) {
      filteredTeachers = filteredTeachers.filter(teacher => 
        teacher.subjects && teacher.subjects.includes(subject)
      );
    }

    // Manual pagination
    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const endIndex = startIndex + parseInt(limit);
    const paginatedTeachers = filteredTeachers.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: filteredTeachers.length,
      pages: Math.ceil(filteredTeachers.length / parseInt(limit)),
      hasNext: endIndex < filteredTeachers.length,
      hasPrev: parseInt(page) > 1
    };

    res.paginated(paginatedTeachers, pagination, 'Teacher search results retrieved successfully');
  });
}

module.exports = new TeacherController(); 