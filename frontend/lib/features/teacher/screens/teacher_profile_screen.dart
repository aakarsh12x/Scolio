import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/features/teacher/utils/teacher_navigation_manager.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  int _currentBottomNavIndex = 4;

  final Map<String, dynamic> _teacherProfile = {
    'name': 'Ms. Johnson',
    'position': 'Mathematics Teacher',
    'email': 'johnson@school.edu',
    'phone': '+1 (555) 123-4567',
    'department': 'Mathematics Department',
    'employeeId': 'T-2023-042',
    'joinDate': 'September 15, 2018',
    'education': 'M.S. Mathematics Education, State University',
    'experience': '8 years',
    'classesAssigned': [
      'Grade 9A - Mathematics',
      'Grade 10B - Mathematics',
      'Grade 8C - Mathematics',
      'Grade 11A - Mathematics',
      'Grade 7D - Mathematics',
    ],
    'address': '123 Teacher Lane, Academic City, AC 12345',
    'bio': 'Dedicated mathematics educator with 8 years of experience teaching middle and high school students. Specializes in making complex mathematical concepts accessible and engaging through interactive teaching methods.',
  };

  @override
  void initState() {
    super.initState();
    _currentBottomNavIndex = TeacherNavigationManager.currentBottomNavIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'My Profile',
        showBackButton: false,
      ),
      drawer: const TeacherDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24.h),
            _buildInfoCard(),
            SizedBox(height: 16.h),
            _buildTeachingInfoCard(),
            SizedBox(height: 16.h),
            _buildAdditionalInfo(),
            SizedBox(height: 16.h),
            _buildActionButtons(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          TeacherNavigationManager.navigateFromBottomBar(index, context);
        },
        isTeacherMode: true,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60.r,
            backgroundColor: const Color(0xFF13315C).withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 80.sp,
              color: const Color(0xFF13315C),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            _teacherProfile['name'],
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _teacherProfile['position'],
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _teacherProfile['department'],
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF13315C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF13315C),
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoItem(Icons.email, 'Email', _teacherProfile['email']),
          SizedBox(height: 12.h),
          _buildInfoItem(Icons.phone, 'Phone', _teacherProfile['phone']),
          SizedBox(height: 12.h),
          _buildInfoItem(Icons.home, 'Address', _teacherProfile['address']),
        ],
      ),
    );
  }

  Widget _buildTeachingInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teaching Information',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF13315C),
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoItem(
              Icons.badge, 'Employee ID', _teacherProfile['employeeId']),
          SizedBox(height: 12.h),
          _buildInfoItem(
              Icons.calendar_today, 'Join Date', _teacherProfile['joinDate']),
          SizedBox(height: 12.h),
          _buildInfoItem(
              Icons.school, 'Education', _teacherProfile['education']),
          SizedBox(height: 12.h),
          _buildInfoItem(
              Icons.work, 'Experience', _teacherProfile['experience']),
          SizedBox(height: 16.h),
          Text(
            'Assigned Classes',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          ..._teacherProfile['classesAssigned'].map<Widget>((className) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(
                    Icons.class_,
                    size: 16.sp,
                    color: const Color(0xFF13315C),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    className,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF13315C),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            _teacherProfile['bio'],
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.snackbar(
                'Edit Profile',
                'Edit profile functionality to be implemented',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF134074),
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13315C),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.snackbar(
                'Change Password',
                'Change password functionality to be implemented',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF134074),
                colorText: Colors.white,
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: const BorderSide(
                color: Color(0xFF13315C),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Change Password',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF13315C),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: const Color(0xFF13315C),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 