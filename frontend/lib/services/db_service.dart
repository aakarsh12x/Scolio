import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// A service class for data operations using the real backend API
class DBService {
  /// Initialize data (connect to real backend)
  Future<bool> initializeTables() async {
    debugPrint('Connecting to Scolio backend API...');
    
    // Test API connection
    final isConnected = await apiService.testConnection();
    
    if (isConnected) {
      debugPrint('✅ Successfully connected to backend API');
      return true;
    } else {
      debugPrint('❌ Failed to connect to backend API');
      debugPrint('Make sure the backend server is running on http://localhost:3000');
      return false;
    }
  }

  /// Insert demo data (handled by backend)
  Future<void> insertDemoData() async {
    debugPrint('Demo data is managed by the backend...');
    // The backend handles sample data creation
  }

  /// Authenticate a user using real backend API
  Future<Map<String, dynamic>?> authenticateUser(String username, String password) async {
    debugPrint('Authenticating user with backend API: $username');
    
    try {
      final user = await apiService.authenticateUser(username, password);
      
      if (user != null) {
        debugPrint('✅ User authenticated successfully: ${user['userType']}');
        return user;
      } else {
        debugPrint('❌ Authentication failed for user: $username');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Authentication error: $e');
      
      // Fallback to demo credentials if API is not available
      debugPrint('Falling back to demo credentials...');
      if (username == 'teacher' && password == 'password') {
        return {
          'userType': 'teacher',
          'userId': 'demo-teacher',
          'username': username,
          'firstName': 'Demo',
          'lastName': 'Teacher',
          'email': 'teacher@demo.com',
        };
      } else if (username == 'student' && password == 'password') {
        return {
          'userType': 'student',
          'userId': 'demo-student',
          'username': username,
          'firstName': 'Demo',
          'lastName': 'Student',
          'email': 'student@demo.com',
        };
      } else if (username == 'parent' && password == 'password') {
        return {
          'userType': 'parent',
          'userId': 'demo-parent',
          'username': username,
          'firstName': 'Demo',
          'lastName': 'Parent',
          'email': 'parent@demo.com',
        };
      }
      
      return null;
    }
  }

  /// Get user details using real backend API
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    debugPrint('Getting user details from backend API for ID: $userId');
    
    try {
      // Try to get user details from the API
      final user = await apiService.getUserById(userId);
      
      if (user != null) {
        debugPrint('✅ User details fetched successfully');
        return {
          'name': '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}',
          'email': user['email'] ?? '',
          'phone': user['phone'] ?? '',
          'role': user['userType'] ?? '',
          'firstName': user['firstName'] ?? '',
          'lastName': user['lastName'] ?? '',
          'userType': user['userType'] ?? '',
        };
      }
    } catch (e) {
      debugPrint('❌ Error fetching user details: $e');
    }
    
    // Fallback to demo data if API fails
    debugPrint('Using fallback demo data for user: $userId');
    if (userId.contains('teacher') || userId == 'T001' || userId == 'demo-teacher') {
      return {
        'name': 'Ms. Shaw',
        'email': 'shaw@school.edu',
        'phone': '555-1234',
        'role': 'Teacher',
        'firstName': 'Ms.',
        'lastName': 'Shaw',
        'userType': 'teacher',
      };
    } else if (userId.contains('student') || userId == 'S001' || userId == 'demo-student') {
      return {
        'name': 'John Doe',
        'email': 'john@student.edu',
        'phone': '555-5678',
        'grade': 'Year 10',
        'firstName': 'John',
        'lastName': 'Doe',
        'userType': 'student',
      };
    } else if (userId.contains('parent') || userId == 'P001' || userId == 'demo-parent') {
      return {
        'name': 'Jane Doe',
        'email': 'jane@parent.com',
        'phone': '555-9012',
        'relation': 'Mother',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'userType': 'parent',
      };
    }
    
    return null;
  }

  // ==================== NEW METHODS FOR REAL DATA ====================

  /// Get all students from backend
  Future<List<dynamic>> getStudents() async {
    try {
      final students = await apiService.getStudents();
      debugPrint('✅ Fetched ${students.length} students from backend');
      return students;
    } catch (e) {
      debugPrint('❌ Error fetching students: $e');
      return [];
    }
  }

  /// Get all teachers from backend
  Future<List<dynamic>> getTeachers() async {
    try {
      final teachers = await apiService.getTeachers();
      debugPrint('✅ Fetched ${teachers.length} teachers from backend');
      return teachers;
    } catch (e) {
      debugPrint('❌ Error fetching teachers: $e');
      return [];
    }
  }

  /// Get all classes from backend
  Future<List<dynamic>> getClasses() async {
    try {
      final classes = await apiService.getClasses();
      debugPrint('✅ Fetched ${classes.length} classes from backend');
      return classes;
    } catch (e) {
      debugPrint('❌ Error fetching classes: $e');
      return [];
    }
  }

  /// Get attendance records from backend
  Future<List<dynamic>> getAttendance({String? classId, String? studentId, String? date}) async {
    try {
      final attendance = await apiService.getAttendance(
        classId: classId,
        studentId: studentId,
        date: date,
      );
      debugPrint('✅ Fetched ${attendance.length} attendance records from backend');
      return attendance;
    } catch (e) {
      debugPrint('❌ Error fetching attendance: $e');
      return [];
    }
  }

  /// Mark attendance
  Future<bool> markAttendance(Map<String, dynamic> attendanceData) async {
    try {
      final result = await apiService.markAttendance(attendanceData);
      if (result != null) {
        debugPrint('✅ Attendance marked successfully');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error marking attendance: $e');
      return false;
    }
  }

  /// Get assignments from backend
  Future<List<dynamic>> getAssignments({String? classId, String? teacherId, String? subject}) async {
    try {
      final assignments = await apiService.getAssignments(
        classId: classId,
        teacherId: teacherId,
        subject: subject,
      );
      debugPrint('✅ Fetched ${assignments.length} assignments from backend');
      return assignments;
    } catch (e) {
      debugPrint('❌ Error fetching assignments: $e');
      return [];
    }
  }

  /// Get exams from backend
  Future<List<dynamic>> getExams({String? classId, String? teacherId, String? subject}) async {
    try {
      final exams = await apiService.getExams(
        classId: classId,
        teacherId: teacherId,
        subject: subject,
      );
      debugPrint('✅ Fetched ${exams.length} exams from backend');
      return exams;
    } catch (e) {
      debugPrint('❌ Error fetching exams: $e');
      return [];
    }
  }

  /// Get student exam history
  Future<List<dynamic>> getStudentExamHistory(String studentId) async {
    try {
      final examHistory = await apiService.getStudentExamHistory(studentId);
      debugPrint('✅ Fetched exam history for student: $studentId');
      return examHistory;
    } catch (e) {
      debugPrint('❌ Error fetching student exam history: $e');
      return [];
    }
  }

  /// Get notifications for user
  Future<List<dynamic>> getUserNotifications(String userId, {String? type, String? priority, bool? unreadOnly}) async {
    try {
      final notifications = await apiService.getUserNotifications(
        userId,
        type: type,
        priority: priority,
        unreadOnly: unreadOnly,
      );
      debugPrint('✅ Fetched ${notifications.length} notifications for user: $userId');
      return notifications;
    } catch (e) {
      debugPrint('❌ Error fetching user notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  Future<bool> markNotificationAsRead(String notificationId, String userId) async {
    try {
      final success = await apiService.markNotificationAsRead(notificationId, userId);
      if (success) {
        debugPrint('✅ Notification marked as read');
      }
      return success;
    } catch (e) {
      debugPrint('❌ Error marking notification as read: $e');
      return false;
    }
  }
} 