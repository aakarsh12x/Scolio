import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherFeeScreen extends StatefulWidget {
  const TeacherFeeScreen({Key? key}) : super(key: key);

  @override
  State<TeacherFeeScreen> createState() => _TeacherFeeScreenState();
}

class _TeacherFeeScreenState extends State<TeacherFeeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Dummy data for student fees
  final List<Map<String, dynamic>> studentFees = [
    {'name': 'Student A1B2C3D4', 'amount': 'RM 1200.00', 'status': 'Unpaid'},
    {'name': 'Student A1B2C3D4', 'amount': 'RM 1200.00', 'status': 'Paid'},
    {'name': 'Student A1B2C3D4', 'amount': 'RM 1200.00', 'status': 'Unpaid'},
    {'name': 'Student A1B2C3D4', 'amount': 'RM 1200.00', 'status': 'Unpaid'},
    {'name': 'Student A1B2C3D4', 'amount': 'RM 1200.00', 'status': 'Unpaid'},
    {'name': 'Student A1B2C3D4', 'amount': 'RM 1200.00', 'status': 'Unpaid'},
    {'name': 'Student A1B2C3D4', 'amount': 'RM 1200.00', 'status': 'Unpaid'},
    {'name': 'Student A1B2C3D4', 'amount': 'RM 1200.00', 'status': 'Unpaid'},
  ];

  // Boolean to track if a reminder is showing
  bool isReminderShowing = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Fees',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF13315C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF13315C)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF13315C)),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const TeacherDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Student Name',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Due Fees',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: studentFees.length,
                  itemBuilder: (context, index) {
                    final fee = studentFees[index];
                    final isPaid = fee['status'] == 'Paid';
                    
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              fee['name'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              fee['amount'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              fee['status'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: isPaid ? Colors.green : Colors.black,
                                fontWeight: isPaid ? FontWeight.bold : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          // Floating Notification Button
          Positioned(
            bottom: 100.h,
            right: 20.w,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isReminderShowing = true;
                });
                
                // Show reminder message at the bottom
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    setState(() {
                      isReminderShowing = false;
                    });
                  }
                });
              },
              backgroundColor: const Color(0xFF13315C),
              child: const Icon(Icons.notifications_outlined, color: Colors.white),
            ),
          ),
          
          // Reminder Message
          if (isReminderShowing)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Reminder Sent Successfully!',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
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