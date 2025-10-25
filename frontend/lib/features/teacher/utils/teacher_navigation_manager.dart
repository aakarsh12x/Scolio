import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/features/teacher/screens/teacher_dashboard_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_calendar_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_profile_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_students_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_classes_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_attendance_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_notifications_screen.dart';

/// A utility class to manage navigation with consistent bottom navigation bar behavior for teachers
class TeacherNavigationManager {
  // Static variables to track current state
  static int currentBottomNavIndex = 0;
  
  // Save user login state to prevent unexpected navigation to startup screen
  static bool isLoggedIn = false;
  
  /// Navigate to the appropriate screen based on the bottom navigation bar index
  static void navigateFromBottomBar(int index, BuildContext context) {
    // Always update the current index
    currentBottomNavIndex = index;
    
    switch (index) {
      case 0: // Home
        Get.offAll(() => const TeacherDashboardScreen());
        break;
      case 1: // Classes
        Get.offAll(() => const TeacherClassesScreen());
        break;
      case 2: // Calendar
        Get.offAll(() => const TeacherCalendarScreen());
        break;
      case 3: // Notification
        Get.offAll(() => const TeacherNotificationsScreen());
        break;
      case 4: // Profile
        Get.offAll(() => const TeacherProfileScreen());
        break;
    }
  }
  
  /// Navigate to specific feature screens while maintaining bottom nav index
  static void navigateToFeatureScreen(String screenName, BuildContext context) {
    Widget? screen;
    
    switch (screenName.toLowerCase()) {
      case 'students':
        screen = const TeacherStudentsScreen();
        break;
      case 'attendance':
        screen = const TeacherAttendanceScreen();
        break;
      case 'grades':
        // Show a message that this feature is coming soon
        Get.snackbar(
          'Coming Soon',
          'Grades feature is coming soon!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF134074),
          colorText: Colors.white,
        );
        return;
      case 'events':
        // Show a message that this feature is coming soon
        Get.snackbar(
          'Coming Soon',
          'Events feature is coming soon!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF134074),
          colorText: Colors.white,
        );
        return;
      case 'notification':
        screen = const TeacherNotificationsScreen();
        break;
      default:
        Get.snackbar(
          'Navigation Error',
          'Screen not found: $screenName',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF134074),
          colorText: Colors.white,
        );
    }
    
    if (screen != null) {
      // Always go to the screen while preserving the current bottom nav index
      Get.to(
        () => screen!,
        transition: Transition.fadeIn,
      );
    }
  }
  
  /// Handle logout properly to avoid accidental navigation
  static void logout() {
    isLoggedIn = false;
    Get.offAllNamed('/startup');
  }
}
