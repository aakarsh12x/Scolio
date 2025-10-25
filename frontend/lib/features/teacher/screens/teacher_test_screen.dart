import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherTestScreen extends StatefulWidget {
  const TeacherTestScreen({Key? key}) : super(key: key);

  @override
  State<TeacherTestScreen> createState() => _TeacherTestScreenState();
}

class _TeacherTestScreenState extends State<TeacherTestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Tests',
        showBackButton: true,
        onLeadingPressed: () {
          Get.back();
        },
      ),
      drawer: const TeacherDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Tests',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.w),
                      title: Text(
                        'Test ${index + 1}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          Text(
                            'Subject: Mathematics',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Date: ${DateTime.now().add(Duration(days: index * 2)).toString().substring(0, 10)}',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Class: Grade ${index + 6}',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                      onTap: () {
                        Get.snackbar(
                          'Test Details',
                          'Test details screen coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: Colors.white,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: NavigationManager.currentBottomNavIndex,
        onTap: (index) {
          NavigationManager.navigateFromBottomBar(index, context);
        },
      ),
    );
  }
} 