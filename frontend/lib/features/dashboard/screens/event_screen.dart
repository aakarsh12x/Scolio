import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_management/components/custom_app_bar.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'School Events',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUpcomingEvents(),
            SizedBox(height: 24.h),
            _buildPastEvents(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF134074),
          ),
        ),
        SizedBox(height: 16.h),
        _buildEventCard(
          'Annual Sports Day',
          'July 25, 2024',
          'Join us for a day of sports and athletic competitions. Parents are welcome to attend and cheer for their children.',
          'assets/images/News.png',
          true,
        ),
        SizedBox(height: 16.h),
        _buildEventCard(
          'Science Fair',
          'August 5, 2024',
          'Students will showcase their science projects. Prizes will be awarded for the best projects in different categories.',
          'assets/images/News.png',
          false,
        ),
        SizedBox(height: 16.h),
        _buildEventCard(
          'Cultural Day',
          'August 15, 2024',
          'Celebrate diversity with performances, food, and activities from different cultures around the world.',
          'assets/images/News.png',
          false,
        ),
      ],
    );
  }

  Widget _buildPastEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Events',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF134074),
          ),
        ),
        SizedBox(height: 16.h),
        _buildPastEventItem(
          'Parent-Teacher Meeting',
          'July 20, 2024',
          Icons.people,
        ),
        _buildPastEventItem(
          'Math Olympiad',
          'July 10, 2024',
          Icons.calculate,
        ),
        _buildPastEventItem(
          'Talent Show',
          'June 30, 2024',
          Icons.emoji_events,
        ),
        _buildPastEventItem(
          'Earth Day Celebration',
          'June 22, 2024',
          Icons.eco,
        ),
      ],
    );
  }

  Widget _buildEventCard(
    String title,
    String date,
    String description,
    String imagePath,
    bool featured,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: featured
            ? Border.all(
                color: const Color(0xFF134074),
                width: 2,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              if (featured)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.sp,
                      color: const Color(0xFF134074),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF134074),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(80.w, 32.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Learn More',
                        style: TextStyle(
                          color: const Color(0xFF134074),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastEventItem(
    String title,
    String date,
    IconData icon,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: const Color(0xFF134074).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF134074),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.photo_library_outlined,
            color: Colors.grey,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
} 