import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:school_management/features/dashboard/screens/news_screen.dart';
import 'package:school_management/features/dashboard/screens/calendar_screen.dart';
import 'package:school_management/features/dashboard/screens/profile_screen.dart';
import 'package:school_management/features/dashboard/screens/notification_screen.dart';
import 'package:school_management/features/dashboard/screens/manage_students_screen.dart';
import 'package:school_management/utils/navigation_manager.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240.w,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMenuItems(context),
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
      decoration: const BoxDecoration(
        color: Color(0xFF13315C),
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
              color: const Color(0xFF13315C),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Username',
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

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.home_rounded,
        'title': 'Home',
        'onTap': () {
          Get.back(); // Close drawer
          NavigationManager.currentBottomNavIndex = 0;
          NavigationManager.navigateFromBottomBar(0, context);
        },
      },
      {
        'icon': Icons.article_rounded,
        'title': 'News',
        'onTap': () {
          Get.back(); // Close drawer
          NavigationManager.currentBottomNavIndex = 1;
          NavigationManager.navigateFromBottomBar(1, context);
        },
      },
      {
        'icon': Icons.calendar_today_rounded,
        'title': 'Calendar',
        'onTap': () {
          Get.back(); // Close drawer
          NavigationManager.currentBottomNavIndex = 2;
          NavigationManager.navigateFromBottomBar(2, context);
        },
      },
      {
        'icon': Icons.notifications_rounded,
        'title': 'Notification',
        'onTap': () {
          Get.back(); // Close drawer
          NavigationManager.currentBottomNavIndex = 3;
          NavigationManager.navigateFromBottomBar(3, context);
        },
      },
      {
        'icon': Icons.person_rounded,
        'title': 'Profile',
        'onTap': () {
          Get.back(); // Close drawer
          NavigationManager.currentBottomNavIndex = 4;
          NavigationManager.navigateFromBottomBar(4, context);
        },
      },
      {
        'icon': Icons.group_add_rounded,
        'title': 'Manage Students',
        'onTap': () {
          Get.back(); // Close drawer
          NavigationManager.navigateToFeatureScreen('manage students', context);
        },
      },
      {
        'icon': Icons.settings_rounded,
        'title': 'Settings',
        'onTap': () {
          Get.back();
          Get.snackbar(
            'Settings',
            'Settings screen is coming soon!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF134074),
            colorText: Colors.white,
          );
        },
      },
      {
        'icon': Icons.language_rounded,
        'title': 'Language',
        'hasSubmenu': true,
        'onTap': () {
          Get.back();
          _showLanguageDialog(context);
        },
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          leading: Icon(
            item['icon'] as IconData,
            color: const Color(0xFF13315C),
            size: 24.sp,
          ),
          title: Text(
            item['title'] as String,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: item.containsKey('hasSubmenu') && item['hasSubmenu'] == true
              ? Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                  size: 22.sp,
                )
              : null,
          onTap: item['onTap'] as Function(),
        );
      },
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
            color: const Color(0xFF13315C),
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
                    backgroundColor: const Color(0xFF134074),
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.back();
          // Show confirmation dialog
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
                    NavigationManager.logout();
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: const Color(0xFF13315C),
                    ),
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        },
        child: Row(
          children: [
            Icon(
              Icons.logout,
              color: const Color(0xFF13315C),
              size: 24.sp,
            ),
            SizedBox(width: 15.w),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF13315C),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 