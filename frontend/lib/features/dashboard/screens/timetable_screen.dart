import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_button.dart';
import 'package:school_management/components/safe_back_screen.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeBackScreen(
      title: 'Timetable',
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: 'Timetable',
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'March - November',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '2024',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildClassTimeRow('English', '8:30 AM', '9:15 AM'),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildClassTimeRow('Mathematics', '8:30 AM', '9:15 AM'),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildClassTimeRow('Science', '8:30 AM', '9:15 AM'),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildClassTimeRow('History', '8:30 AM', '9:15 AM'),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildClassTimeRow('ICT', '8:30 AM', '9:15 AM'),
                    Divider(height: 1.h, color: Colors.grey.shade200),
                    _buildClassTimeRow('Economics', '8:30 AM', '9:15 AM'),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: CustomButton(
                  text: 'Download',
                  width: 150.w,
                  height: 45.h,
                  borderRadius: 25.r,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassTimeRow(String subject, String startTime, String endTime) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF13315C),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                startTime,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              Text(
                endTime,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 