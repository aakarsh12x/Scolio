import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// API service for connecting to the Scolio School Management backend
class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  static const Duration timeout = Duration(seconds: 30);

  // HTTP client
  final http.Client _client = http.Client();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Generic method to handle API responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  /// Test API connection
  Future<bool> testConnection() async {
    try {
      final response = await _client.get(
        Uri.parse('http://localhost:3000/health'),
        headers: _headers,
      ).timeout(timeout);
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('API connection test failed: $e');
      return false;
    }
  }

  // ==================== USER AUTHENTICATION ====================

  /// Authenticate user
  Future<Map<String, dynamic>?> authenticateUser(String username, String password) async {
    try {
      // For now, we'll use a simple check against users in the database
      // In a real app, this would be a proper authentication endpoint
      final users = await getUsers();
      
      for (var user in users) {
        if (user['username'] == username) {
          // In a real app, password would be hashed and verified properly
          return {
            'userType': user['userType'],
            'userId': user['id'],
            'username': user['username'],
            'firstName': user['firstName'],
            'lastName': user['lastName'],
            'email': user['email'],
          };
        }
      }
      return null;
    } catch (e) {
      debugPrint('Authentication error: $e');
      return null;
    }
  }

  // ==================== USER MANAGEMENT ====================

  /// Get all users
  Future<List<dynamic>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/users'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'] ?? [];
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  /// Get user by ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error fetching user: $e');
      return null;
    }
  }

  /// Create user
  Future<Map<String, dynamic>?> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/users'),
        headers: _headers,
        body: json.encode(userData),
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error creating user: $e');
      return null;
    }
  }

  // ==================== TEACHER MANAGEMENT ====================

  /// Get all teachers
  Future<List<dynamic>> getTeachers() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/teachers'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'] ?? [];
    } catch (e) {
      debugPrint('Error fetching teachers: $e');
      return [];
    }
  }

  /// Get teacher by ID
  Future<Map<String, dynamic>?> getTeacherById(String teacherId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/teachers/$teacherId'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error fetching teacher: $e');
      return null;
    }
  }

  // ==================== STUDENT MANAGEMENT ====================

  /// Get all students
  Future<List<dynamic>> getStudents() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/students'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'] ?? [];
    } catch (e) {
      debugPrint('Error fetching students: $e');
      return [];
    }
  }

  /// Get student by ID
  Future<Map<String, dynamic>?> getStudentById(String studentId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/students/$studentId'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error fetching student: $e');
      return null;
    }
  }

  // ==================== CLASS MANAGEMENT ====================

  /// Get all classes
  Future<List<dynamic>> getClasses() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/classes'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'] ?? [];
    } catch (e) {
      debugPrint('Error fetching classes: $e');
      return [];
    }
  }

  /// Get class by ID
  Future<Map<String, dynamic>?> getClassById(String classId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/classes/$classId'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error fetching class: $e');
      return null;
    }
  }

  // ==================== ATTENDANCE MANAGEMENT ====================

  /// Get attendance records
  Future<List<dynamic>> getAttendance({String? classId, String? studentId, String? date}) async {
    try {
      String url = '$baseUrl/attendance';
      List<String> queryParams = [];
      
      if (classId != null) queryParams.add('classId=$classId');
      if (studentId != null) queryParams.add('studentId=$studentId');
      if (date != null) queryParams.add('date=$date');
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }
      
      final response = await _client.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'] ?? [];
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
      return [];
    }
  }

  /// Mark attendance
  Future<Map<String, dynamic>?> markAttendance(Map<String, dynamic> attendanceData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/attendance'),
        headers: _headers,
        body: json.encode(attendanceData),
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error marking attendance: $e');
      return null;
    }
  }

  // ==================== ASSIGNMENT MANAGEMENT ====================

  /// Get assignments
  Future<List<dynamic>> getAssignments({String? classId, String? teacherId, String? subject}) async {
    try {
      String url = '$baseUrl/assignments';
      List<String> queryParams = [];
      
      if (classId != null) queryParams.add('classId=$classId');
      if (teacherId != null) queryParams.add('teacherId=$teacherId');
      if (subject != null) queryParams.add('subject=$subject');
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }
      
      final response = await _client.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'] ?? [];
    } catch (e) {
      debugPrint('Error fetching assignments: $e');
      return [];
    }
  }

  /// Create assignment
  Future<Map<String, dynamic>?> createAssignment(Map<String, dynamic> assignmentData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/assignments'),
        headers: _headers,
        body: json.encode(assignmentData),
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error creating assignment: $e');
      return null;
    }
  }

  /// Submit assignment
  Future<Map<String, dynamic>?> submitAssignment(String assignmentId, Map<String, dynamic> submissionData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/assignments/$assignmentId/submit'),
        headers: _headers,
        body: json.encode(submissionData),
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error submitting assignment: $e');
      return null;
    }
  }

  // ==================== EXAM MANAGEMENT ====================

  /// Get exams
  Future<List<dynamic>> getExams({String? classId, String? teacherId, String? subject}) async {
    try {
      String url = '$baseUrl/exams';
      List<String> queryParams = [];
      
      if (classId != null) queryParams.add('classId=$classId');
      if (teacherId != null) queryParams.add('teacherId=$teacherId');
      if (subject != null) queryParams.add('subject=$subject');
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }
      
      final response = await _client.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'] ?? [];
    } catch (e) {
      debugPrint('Error fetching exams: $e');
      return [];
    }
  }

  /// Get student exam history
  Future<List<dynamic>> getStudentExamHistory(String studentId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/exams/student/$studentId'),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'] ?? [];
    } catch (e) {
      debugPrint('Error fetching student exam history: $e');
      return [];
    }
  }

  // ==================== NOTIFICATION MANAGEMENT ====================

  /// Get notifications for user
  Future<List<dynamic>> getUserNotifications(String userId, {String? type, String? priority, bool? unreadOnly}) async {
    try {
      String url = '$baseUrl/notifications/user/$userId';
      List<String> queryParams = [];
      
      if (type != null) queryParams.add('type=$type');
      if (priority != null) queryParams.add('priority=$priority');
      if (unreadOnly == true) queryParams.add('unreadOnly=true');
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }
      
      final response = await _client.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data']['notifications'] ?? [];
    } catch (e) {
      debugPrint('Error fetching user notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  Future<bool> markNotificationAsRead(String notificationId, String userId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: _headers,
        body: json.encode({'userId': userId}),
      ).timeout(timeout);
      
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }

  /// Create notification (for teachers/admins)
  Future<Map<String, dynamic>?> createNotification(Map<String, dynamic> notificationData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/notifications'),
        headers: _headers,
        body: json.encode(notificationData),
      ).timeout(timeout);
      
      final data = _handleResponse(response);
      return data['data'];
    } catch (e) {
      debugPrint('Error creating notification: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}

/// Singleton instance of ApiService
final apiService = ApiService(); 