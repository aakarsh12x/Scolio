import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:school_management/features/dashboard/screens/profile_screen.dart';
import 'package:school_management/features/dashboard/screens/timetable_screen.dart';
import 'package:school_management/features/dashboard/screens/achievement_screen.dart';
import 'package:school_management/features/dashboard/screens/news_screen.dart';
import 'package:school_management/features/dashboard/screens/calendar_screen.dart';
import 'package:school_management/features/dashboard/screens/manage_students_screen.dart';
import 'package:school_management/features/dashboard/screens/notification_screen.dart';
import 'package:school_management/features/onboarding/screens/forgot_password_screen.dart';
import 'package:school_management/features/onboarding/screens/login_screen.dart';
import 'package:school_management/features/onboarding/screens/logo_screen.dart';
import 'package:school_management/features/onboarding/screens/start_up_screen.dart';
import 'package:school_management/features/onboarding/screens/teacher_login_screen_new.dart';
import 'package:school_management/features/teacher/screens/teacher_dashboard_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_profile_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_calendar_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_classes_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_students_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_notifications_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/rendering.dart';
import 'package:school_management/theme/app_theme.dart';
import 'package:school_management/utils/navigation_manager.dart';
// DynamoDB service will be added later
// import 'package:school_management/services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Reset navigation state to avoid any stale state
  NavigationManager.resetNavigationState();
  
  // Disable overflow errors in UI (red indicators)
  debugPaintSizeEnabled = false;
  // For Flutter 3.0+, this is handled differently
  // debugOverflowIndicatorStyle = null; 
  
  // Configure system UI to support notches and modern displays
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  /* DynamoDB initialization - will be added later
  // Initialize in offline mode
  final dbService = DBService();
  final isInitialized = await dbService.initializeTables();
  
  if (isInitialized) {
    print('App initialized in offline mode successfully');
    // Use pre-populated demo data
    await dbService.insertDemoData();
  } else {
    print('Failed to initialize app in offline mode');
  }
  */
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (__, child) {
          return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'scolio',
          theme: AppTheme.lightTheme,
          // Enable full screen app support
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const LogoScreen()),
            GetPage(name: '/startup', page: () => const StartUpScreen()),
            GetPage(
              name: '/login', 
              page: () {
                final Map<String, dynamic> args = Get.arguments ?? {"userType": "Parents"};
                return LoginScreen(userType: args["userType"] ?? "Parents");
              },
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/teacher_login', 
              page: () => const TeacherLoginScreen(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/forgot-password', 
              page: () => const ForgotPasswordScreen(),
              transition: Transition.rightToLeft,
            ),
            
            // Parent routes
            GetPage(
              name: '/dashboard', 
              page: () => const DashboardScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/profile', 
              page: () => const ProfileScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/timetable', 
              page: () => const TimetableScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/news', 
              page: () => const NewsScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/calendar', 
              page: () => const CalendarScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/achievement', 
              page: () => const AchievementScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/manage_students', 
              page: () => const ManageStudentsScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/notification', 
              page: () => const NotificationScreen(),
              transition: Transition.fadeIn,
            ),
            
            // Teacher routes
            GetPage(
              name: '/teacher_dashboard', 
              page: () => const TeacherDashboardScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/teacher_profile', 
              page: () => const TeacherProfileScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/teacher_calendar', 
              page: () => const TeacherCalendarScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/teacher_classes', 
              page: () => const TeacherClassesScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/teacher_students', 
              page: () => const TeacherStudentsScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: '/teacher_notifications', 
              page: () => const TeacherNotificationsScreen(),
              transition: Transition.fadeIn,
            ),
          ],
          );
      },
    );
  }
}
