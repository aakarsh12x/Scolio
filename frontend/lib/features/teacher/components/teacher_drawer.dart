import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/features/teacher/screens/teacher_dashboard_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_classes_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_calendar_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_notification_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_profile_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_students_screen.dart';
import 'package:school_management/utils/navigation_manager.dart';
import 'package:school_management/utils/constants.dart';
import 'package:school_management/widgets/custom_drawer_item.dart';
import 'package:school_management/utils/app_screen_type.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240.w,
      child: Container(
        color: kPrimaryColor,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMenu(context),
            ),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 36.sp,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Teacher Name',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomDrawerItem(
            title: 'Home',
            icon: Icons.home_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.currentBottomNavIndex = 0;
              NavigationManager.navigateFromBottomBar(0, context);
            },
          ),
          CustomDrawerItem(
            title: 'Classes',
            icon: Icons.class_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.navigateToFeatureScreen('class', context);
            },
          ),
          CustomDrawerItem(
            title: 'Calendar',
            icon: Icons.calendar_today_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.currentBottomNavIndex = 2;
              NavigationManager.navigateFromBottomBar(2, context);
            },
          ),
          CustomDrawerItem(
            title: 'Notification',
            icon: Icons.notifications_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.currentBottomNavIndex = 3;
              NavigationManager.navigateFromBottomBar(3, context);
            },
          ),
          CustomDrawerItem(
            title: 'Profile',
            icon: Icons.person_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.currentBottomNavIndex = 4;
              NavigationManager.navigateFromBottomBar(4, context);
            },
          ),
          CustomDrawerItem(
            title: 'Students',
            icon: Icons.group_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.currentScreenType = AppScreenType.feature;
              Get.to(() => const TeacherStudentsScreen(), transition: Transition.fadeIn);
            },
          ),
          CustomDrawerItem(
            title: 'Timetable',
            icon: Icons.schedule_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.navigateToFeatureScreen('timetable', context);
            },
          ),
          CustomDrawerItem(
            title: 'Attendance',
            icon: Icons.fact_check_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.navigateToFeatureScreen('attendance', context);
            },
          ),
          CustomDrawerItem(
            title: 'Achievements',
            icon: Icons.emoji_events_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.navigateToFeatureScreen('achievement', context);
            },
          ),
          CustomDrawerItem(
            title: 'Report Cards',
            icon: Icons.assignment_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.navigateToFeatureScreen('report card', context);
            },
          ),
          CustomDrawerItem(
            title: 'Tests',
            icon: Icons.quiz_rounded,
            onTap: () {
              Get.back(); // Close drawer
              NavigationManager.navigateToFeatureScreen('test', context);
            },
          ),
          CustomDrawerItem(
            title: 'Settings',
            icon: Icons.settings_rounded,
            onTap: () {
              Get.back();
              Get.snackbar(
                'Settings',
                'Settings screen is coming soon!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: kSecondaryColor,
                colorText: Colors.white,
              );
            },
          ),
          CustomDrawerItem(
            title: 'Language',
            icon: Icons.language_rounded,
            onTap: () {
              Get.back();
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Language',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  languages[index],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.snackbar(
                    'Language Changed',
                    'Language set to ${languages[index]}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: kSecondaryColor,
                    colorText: Colors.white,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TextButton(
        onPressed: () {
          // Show confirmation dialog
          Get.dialog(
            AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    // Make sure to use NavigationManager for consistent logout behavior
                    NavigationManager.logout();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: 20.sp,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 