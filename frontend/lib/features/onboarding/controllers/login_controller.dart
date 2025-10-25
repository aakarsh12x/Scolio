import 'package:flutter/material.dart';
import 'package:get/get.dart';
// DynamoDB service will be added later
// import 'package:school_management/services/db_service.dart';
import 'package:school_management/utils/navigation_manager.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_dashboard_screen.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  // DynamoDB service will be added later
  // final DBService _dbService = DBService();
  
  // Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
  
  // Simple login function that accepts any valid email and password
  Future<bool> attemptLogin(String userType, BuildContext context) async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    // Check if username is in valid email format
    final bool isValidEmail = GetUtils.isEmail(usernameController.text.trim());
    if (!isValidEmail) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    isLoading.value = true;
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    isLoading.value = false;
    
    // Determine if teacher mode based on user type
    bool isTeacher = userType.toLowerCase() == 'teacher' || 
                    userType.toLowerCase() == 'teachers';
    
    // Use the NavigationManager's login method to properly set state
    NavigationManager.loginUser(isTeacher);
    
    // Navigate to the appropriate dashboard using standard navigation
    if (isTeacher) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TeacherDashboardScreen()),
        (route) => false
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false
      );
    }
    
    return true;
  }
  
  /* DynamoDB related code - will be added later
  // Login function
  Future<bool> login(String userType) async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both username and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    isLoading.value = true;
    
    try {
      final user = await _dbService.authenticateUser(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
      
      isLoading.value = false;
      
      if (user != null) {
        if (user['userType'] == userType.toLowerCase()) {
          // Navigate to appropriate dashboard based on user type
          if (userType.toLowerCase() == 'teacher') {
            Get.offAllNamed('/teacher_dashboard');
          } else if (userType.toLowerCase() == 'student') {
            Get.offAllNamed('/dashboard');
          } else if (userType.toLowerCase() == 'parents') {
            Get.offAllNamed('/dashboard');
          }
          return true;
        } else {
          Get.snackbar(
            'Authentication Error',
            'Invalid account type for this login',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Authentication Error',
          'Invalid username or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred during login: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
  
  // Demo login function (for when DynamoDB is not available)
  Future<bool> demoLogin(String userType) async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both username and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    isLoading.value = true;
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    isLoading.value = false;
    
    // Hardcoded credentials for demo
    if (userType.toLowerCase() == 'teacher' && 
        usernameController.text == 'teacher' && 
        passwordController.text == 'password') {
      Get.offAllNamed('/teacher_dashboard');
      return true;
    } else if ((userType.toLowerCase() == 'student' || userType.toLowerCase() == 'parents') && 
              usernameController.text == 'student' && 
              passwordController.text == 'password') {
      Get.offAllNamed('/dashboard');
      return true;
    } else {
      Get.snackbar(
        'Authentication Error',
        'Invalid username or password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
  */
  
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
} 