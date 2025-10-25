import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/components/custom_card.dart';
import 'package:school_management/components/custom_headin_text.dart';
import 'package:school_management/features/onboarding/screens/logo_screen.dart';
import 'package:school_management/utils/navigation_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Initialize with the profile tab selected
  @override
  void initState() {
    super.initState();
    // Ensure current bottom nav index is set to Profile
    NavigationManager.currentBottomNavIndex = 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24.h),
            _buildSectionTitle('Account Settings'),
            SizedBox(height: 16.h),
            _buildSettingsOptions(),
            SizedBox(height: 24.h),
            _buildSectionTitle('About'),
            SizedBox(height: 16.h),
            _buildAboutOptions(),
            SizedBox(height: 40.h),
            _buildLogoutButton(),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: NavigationManager.currentBottomNavIndex,
        onTap: (index) {
          // Use the NavigationManager to handle navigation
          NavigationManager.navigateFromBottomBar(index, context);
        },
        isTeacherMode: NavigationManager.isTeacherMode,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return CustomCard(
      padding: EdgeInsets.all(20.sp),
      child: Row(
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF134074),
                width: 2.w,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35.r),
              child: Image.asset(
                'assets/icons/profile.png',
                width: 60.w,
                height: 60.w,
                fit: BoxFit.cover,
                color: const Color(0xFF134074),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeadingText(
                  headingText: 'John Doe',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Arial',
                ),
                SizedBox(height: 4.h),
                Text(
                  'Student ID: SMY12346KL',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Edit profile
            },
            icon: Icon(
              Icons.edit,
              color: const Color(0xFF134074),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomHeadingText(
      headingText: title,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Arial',
      color: const Color(0xFF134074),
    );
  }

  Widget _buildSettingsOptions() {
    return Column(
      children: [
        _buildSettingsTile(
          'Personal Information',
          Icons.person_outline,
          () {},
        ),
        SizedBox(height: 12.h),
        _buildSettingsTile(
          'Change Password',
          Icons.lock_outline,
          () {},
        ),
        SizedBox(height: 12.h),
        _buildSettingsTile(
          'Notifications',
          Icons.notifications_none_rounded,
          () {},
        ),
        SizedBox(height: 12.h),
        _buildSettingsTile(
          'Language',
          Icons.language_outlined,
          () {},
        ),
      ],
    );
  }

  Widget _buildAboutOptions() {
    return Column(
      children: [
        _buildSettingsTile(
          'About Scolio',
          Icons.info_outline,
          () {},
        ),
        SizedBox(height: 12.h),
        _buildSettingsTile(
          'Privacy Policy',
          Icons.privacy_tip_outlined,
          () {},
        ),
        SizedBox(height: 12.h),
        _buildSettingsTile(
          'Terms & Conditions',
          Icons.description_outlined,
          () {},
        ),
        SizedBox(height: 12.h),
        _buildSettingsTile(
          'Help & Support',
          Icons.help_outline,
          () {},
        ),
      ],
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return CustomCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF134074),
            size: 24.sp,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 16.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return CustomCard(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      backgroundColor: const Color(0xFFFFEEEE),
      onTap: () {
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
                  // Use the navigation manager for consistent logout behavior
                  NavigationManager.logout();
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
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.logout,
            color: Colors.red,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            'Logout',
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'Arial',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
} 