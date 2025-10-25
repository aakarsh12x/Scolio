import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_button.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Attendance',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Attended Box
                  Expanded(
                    child: Container(
                      height: 180.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13315C),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '30',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 70.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Attended',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Absent Box
                  Expanded(
                    child: Container(
                      height: 180.h,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 70.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Absent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Progress Indicator
              Stack(
                children: [
                  Container(
                    height: 6.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                  Container(
                    height: 6.h,
                    width: MediaQuery.of(context).size.width * 0.8, // 30 of 33 = ~91%
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'Activity',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              _buildAttendanceItem('05/01/2024', 'Student Attended Class', '8:00PM'),
              _buildDivider(),
              _buildAttendanceItem('04/01/2024', 'Student On Leave', '-'),
              _buildDivider(),
              _buildAttendanceItem('03/01/2024', 'Student Attended Class', '8:00PM'),
              _buildDivider(),
              _buildAttendanceItem('02/01/2024', 'Student Attended Class', '8:00PM'),
              _buildDivider(),
              _buildAttendanceItem('01/01/2024', 'Student Attended Class', '8:00PM'),
              SizedBox(height: 30.h),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 10.h),
              // Apply for leave section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apply for a leave',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'To approve leave, upload the student\'s leave application or medical certificate (MC).',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: 'Upload',
                      width: 150.w,
                      height: 45.h,
                      borderRadius: 25.r,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(String date, String status, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              date,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade200,
      height: 1.h,
    );
  }
} 