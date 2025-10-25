import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:school_management/features/dashboard/screens/news_screen.dart';
import 'package:school_management/features/dashboard/screens/calendar_screen.dart';
import 'package:school_management/features/dashboard/screens/profile_screen.dart';
import 'package:school_management/features/dashboard/screens/achievement_screen.dart';
import 'package:school_management/features/dashboard/screens/timetable_screen.dart';
import 'package:school_management/features/dashboard/screens/attendance_screen.dart';
import 'package:school_management/features/dashboard/screens/class_screen.dart';
import 'package:school_management/features/dashboard/screens/report_card_screen.dart';
import 'package:school_management/features/dashboard/screens/event_screen.dart';
import 'package:school_management/features/dashboard/screens/fee_screen.dart';
import 'package:school_management/features/dashboard/screens/health_screen.dart';
import 'package:school_management/features/dashboard/screens/manage_students_screen.dart';
import 'package:school_management/features/dashboard/screens/notification_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_dashboard_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_classes_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_news_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_calendar_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_notifications_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_profile_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_health_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_fee_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_event_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_test_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_timetable_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_achievement_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_report_card_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_attendance_screen.dart';
import 'package:school_management/utils/constants.dart';
import 'package:school_management/utils/app_screen_type.dart';

/// A utility class to manage navigation with consistent bottom navigation bar behavior
class NavigationManager {
  // Static variables to track current state
  static int currentBottomNavIndex = 0;
  
  // Flag to identify if we're in teacher mode
  static bool isTeacherMode = false;
  
  // Save user login state to prevent unexpected navigation to startup screen
  static bool isLoggedIn = false; // Default to false to ensure proper login flow
  
  // Track the current screen type: main screen or feature screen
  static AppScreenType currentScreenType = AppScreenType.main;
  
  // Main screen names to track where to return to
  static String currentMainScreen = '';
  
  // Keep track of screens in navigation history to prevent unexpected behavior
  static List<String> navigationHistory = [];
  
  // The key to prevent login loops - track if we're currently in the login process
  static bool isLoginInProgress = false;
  
  // Track if we're currently on the login screen (to prevent unwanted navigation)
  static bool isOnLoginScreen = false;
  
  /// Login the user
  static void loginUser(bool isTeacher) {
    isLoggedIn = true;
    isTeacherMode = isTeacher;
    isLoginInProgress = false;
    isOnLoginScreen = false;
    
    // Reset bottom nav index
    currentBottomNavIndex = 0;
    
    // Set initial screen in navigation history
    if (isTeacher) {
      navigationHistory = ['TeacherDashboardScreen'];
    } else {
      navigationHistory = ['DashboardScreen'];
    }
  }
  
  /// Check if user is logged in and redirect as needed
  static void checkAuthAndRedirect() {
    // Avoid redirecting if we're already on a login screen
    if (isOnLoginScreen) {
      return;
    }
    
    if (isLoggedIn) {
      // Already logged in, go to the appropriate dashboard
      if (isTeacherMode) {
        Get.offAll(() => const TeacherDashboardScreen(), transition: Transition.fadeIn);
      } else {
        Get.offAll(() => const DashboardScreen(), transition: Transition.fadeIn);
      }
    } else if (!isLoginInProgress) {
      // Not logged in and not in the middle of login process, go to startup
      isLoginInProgress = true; // Set flag to prevent login loops
      Get.offAllNamed('/startup');
    }
    // If login is in progress, don't redirect anywhere (prevents loops)
  }
  
  /// Navigate to the appropriate screen based on the bottom navigation bar index
  static void navigateFromBottomBar(int index, BuildContext context) {
    // Always update the current index
    currentBottomNavIndex = index;
    
    // Set screen type to main since we're navigating to a bottom nav screen
    currentScreenType = AppScreenType.main;
    
    if (isTeacherMode) {
      // Teacher mode navigation
      switch (index) {
        case 0: // Home
          currentMainScreen = 'TeacherDashboardScreen';
          Get.offAll(() => const TeacherDashboardScreen());
          navigationHistory = ['TeacherDashboardScreen'];
          break;
        case 1: // News for teacher mode
          currentMainScreen = 'TeacherNewsScreen';
          Get.offAll(() => const TeacherNewsScreen());
          navigationHistory = ['TeacherNewsScreen'];
          break;
        case 2: // Calendar
          currentMainScreen = 'TeacherCalendarScreen';
          Get.offAll(() => const TeacherCalendarScreen());
          navigationHistory = ['TeacherCalendarScreen'];
          break;
        case 3: // Notification
          currentMainScreen = 'TeacherNotificationsScreen';
          Get.offAll(() => const TeacherNotificationsScreen());
          navigationHistory = ['TeacherNotificationsScreen'];
          break;
        case 4: // Profile
          currentMainScreen = 'TeacherProfileScreen';
          Get.offAll(() => const TeacherProfileScreen());
          navigationHistory = ['TeacherProfileScreen'];
          break;
      }
    } else {
      // Parent mode navigation
      switch (index) {
        case 0: // Home
          currentMainScreen = 'DashboardScreen';
          Get.offAll(() => const DashboardScreen());
          navigationHistory = ['DashboardScreen'];
          break;
        case 1: // News
          currentMainScreen = 'NewsScreen';
          Get.offAll(() => const NewsScreen());
          navigationHistory = ['NewsScreen'];
          break;
        case 2: // Calendar
          currentMainScreen = 'CalendarScreen';
          Get.offAll(() => const CalendarScreen());
          navigationHistory = ['CalendarScreen'];
          break;
        case 3: // Notification
          currentMainScreen = 'NotificationScreen';
          Get.offAll(() => const NotificationScreen());
          navigationHistory = ['NotificationScreen'];
          break;
        case 4: // Profile
          currentMainScreen = 'ProfileScreen';
          Get.offAll(() => const ProfileScreen());
          navigationHistory = ['ProfileScreen'];
          break;
      }
    }
  }
  
  /// Navigate to specific feature screens while maintaining bottom nav index
  static void navigateToFeatureScreen(String screenName, BuildContext context) {
    Widget? screen;
    String screenClassName = '';
    
    // Set screen type to feature since we're navigating to a feature screen
    currentScreenType = AppScreenType.feature;
    
    if (isTeacherMode) {
      // Teacher mode feature screens
      switch (screenName.toLowerCase()) {
        case 'timetable':
          screen = const TeacherTimetableScreen();
          screenClassName = 'TeacherTimetableScreen';
          break;
        case 'attendance':
          screen = const TeacherAttendanceScreen();
          screenClassName = 'TeacherAttendanceScreen';
          break;
        case 'class':
          screen = const TeacherClassesScreen();
          screenClassName = 'TeacherClassesScreen';
          break;
        case 'health':
          screen = const TeacherHealthScreen();
          screenClassName = 'TeacherHealthScreen';
          break;
        case 'fee':
          screen = const TeacherFeeScreen();
          screenClassName = 'TeacherFeeScreen';
          break;
        case 'event':
          screen = const TeacherEventScreen();
          screenClassName = 'TeacherEventScreen';
          break;
        case 'test':
          screen = const TeacherTestScreen();
          screenClassName = 'TeacherTestScreen';
          break;
        case 'achievement':
          screen = const TeacherAchievementScreen();
          screenClassName = 'TeacherAchievementScreen';
          break;
        case 'report card':
          screen = const TeacherReportCardScreen();
          screenClassName = 'TeacherReportCardScreen';
          break;
        case 'notification':
          screen = const TeacherNotificationsScreen();
          screenClassName = 'TeacherNotificationsScreen';
          break;
        default:
          Get.snackbar(
            'Navigation Error',
            'Screen not found: $screenName',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: kSecondaryColor,
            colorText: Colors.white,
          );
      }
    } else {
      // Parent mode feature screens
      switch (screenName.toLowerCase()) {
        case 'timetable':
          screen = const TimetableScreen();
          screenClassName = 'TimetableScreen';
          break;
        case 'attendance':
          screen = const AttendanceScreen();
          screenClassName = 'AttendanceScreen';
          break;
        case 'class':
          screen = const ClassScreen();
          screenClassName = 'ClassScreen';
          break;
        case 'report card':
          screen = const ReportCardScreen();
          screenClassName = 'ReportCardScreen';
          break;
        case 'event':
          screen = const EventScreen();
          screenClassName = 'EventScreen';
          break;
        case 'achievement':
          screen = const AchievementScreen();
          screenClassName = 'AchievementScreen';
          break;
        case 'fee':
          screen = const FeeScreen();
          screenClassName = 'FeeScreen';
          break;
        case 'health':
          screen = const HealthScreen();
          screenClassName = 'HealthScreen';
          break;
        case 'manage students':
          screen = const ManageStudentsScreen();
          screenClassName = 'ManageStudentsScreen';
          break;
        case 'notification':
          screen = const NotificationScreen();
          screenClassName = 'NotificationScreen';
          break;
        default:
          Get.snackbar(
            'Navigation Error',
            'Screen not found: $screenName',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: kSecondaryColor,
            colorText: Colors.white,
          );
      }
    }
    
    if (screen != null) {
      // Save the screen name in navigation history
      navigationHistory.add(screenClassName);
      
      // Always go to the screen while preserving the current bottom nav index
      Get.to(
        () => screen!,
        transition: Transition.fadeIn,
      );
    }
  }

  /// Handle back navigation
  static Future<bool> handleBackNavigation() async {
    if (currentScreenType == AppScreenType.feature) {
      // We're navigating back from a feature screen
      // Remove the current screen from navigation history
      if (navigationHistory.isNotEmpty) {
        navigationHistory.removeLast();
      }
      // Let the system handle the back press
      return true;
    } else {
      // We're on a main screen
      if (currentBottomNavIndex != 0) {
        // If not on home tab, go to home tab
        navigateFromBottomBar(0, Get.context!);
        return false; // Don't exit app
      } else {
        // On home tab, show exit confirmation
        bool shouldExit = await showExitConfirmDialog();
        return shouldExit;
      }
    }
  }

  /// Show a confirmation dialog before exiting the app
  static Future<bool> showExitConfirmDialog() async {
    bool result = false;
    await Get.dialog(
      AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text(
              'Exit',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    ).then((value) => result = value ?? false);
    
    return result;
  }

  /// Handle logout properly to avoid accidental navigation
  static void logout() {
    // Only log out if we really want to logout
    showLogoutConfirmDialog();
  }
  
  /// Show a confirmation dialog before logging out
  static void showLogoutConfirmDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              isLoggedIn = false;
              isTeacherMode = false;
              isLoginInProgress = false;
              // Clear navigation history
              navigationHistory.clear();
              // Use named route instead of directly navigating to StartUpScreen
              Get.offAllNamed('/startup');
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
  
  /// Reset the navigation state completely - used when app starts
  static void resetNavigationState() {
    isLoggedIn = false;
    isTeacherMode = false;
    isLoginInProgress = false;
    isOnLoginScreen = false;
    navigationHistory.clear();
    currentBottomNavIndex = 0;
    currentScreenType = AppScreenType.main;
    currentMainScreen = '';
  }
} 