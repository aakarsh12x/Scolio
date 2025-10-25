import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/components/custom_card.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/components/custom_headin_text.dart';
import 'package:school_management/features/dashboard/screens/profile_screen.dart';
import 'package:school_management/features/dashboard/screens/timetable_screen.dart';
import 'package:school_management/features/dashboard/screens/attendance_screen.dart';
import 'package:school_management/features/dashboard/screens/class_screen.dart';
import 'package:school_management/features/dashboard/screens/report_card_screen.dart';
import 'package:school_management/features/dashboard/screens/event_screen.dart';
import 'package:school_management/features/dashboard/screens/achievement_screen.dart';
import 'package:school_management/features/dashboard/screens/fee_screen.dart';
import 'package:school_management/features/dashboard/screens/health_screen.dart';
import 'package:school_management/features/dashboard/screens/news_screen.dart';
import 'package:school_management/features/dashboard/screens/calendar_screen.dart';
import 'package:school_management/utils/navigation_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Set the current bottom nav index to Home (index 0)
    NavigationManager.currentBottomNavIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Dashboard',
        onLeadingPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
              SizedBox(height: 16.h),
              _buildNewsCard(),
              SizedBox(height: 16.h),
            _buildGridMenu(),
          ],
        ),
        ),
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: NavigationManager.currentBottomNavIndex,
        onTap: (index) {
          if (index == NavigationManager.currentBottomNavIndex) return;
          
          // Use the NavigationManager to handle navigation consistently
          NavigationManager.navigateFromBottomBar(index, context);
        },
        isTeacherMode: NavigationManager.isTeacherMode,
      ),
    );
  }

  Widget _buildProfileCard() {
    return CustomCard(
      padding: EdgeInsets.zero,
      height: 180.h,
      gradient: null,
      backgroundColor: Colors.transparent,
      borderRadius: 12.r,
      shadowColor: Colors.black.withOpacity(0.1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            // Left side - darker blue
            Expanded(
              flex: 4,  // Adjusted to make left side slightly smaller
      child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: const BoxDecoration(
                  color: Color(0xFF13315C),
        ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomHeadingText(
                      headingText: 'Scolio',
                    color: Color(0xFFFFFFFF),
                    fontSize: 32,
                  ),
                    SizedBox(height: 12.h),
                    _buildWhiteText('Class\nYear 10', FontWeight.w700, 12),
                ],
              ),
              ),
            ),
            // Right side - slightly lighter blue
            Expanded(
              flex: 5,  // Adjusted to make right side slightly larger
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: const BoxDecoration(
                  color: Color(0xFF134074),
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        _buildWhiteText('John Doe', FontWeight.w700, 18),
                      Text(
                        'SMY12346KL',
                        style: TextStyle(
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: const Color(0xFFFFFFFF),
                          ),
                      ),
                    ],
                  ),
                    SizedBox(height: 16.h),
                    _buildWhiteText('Enrolled On\n01/06/2024', FontWeight.w700, 12),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard() {
    return GestureDetector(
      onTap: () {
        NavigationManager.currentBottomNavIndex = 1;
        NavigationManager.navigateFromBottomBar(1, context);
      },
      child: CustomCard(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              Image.asset(
                "assets/images/News.png",
                width: double.infinity,
                height: 180.h,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Latest News & Updates',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteText(String text, FontWeight fontWeight, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Arial',
          fontWeight: fontWeight,
        fontSize: fontSize.sp,
        color: const Color(0xFFFFFFFF),
        overflow: TextOverflow.ellipsis,
      ),
      maxLines: 2,
    );
  }

  Widget _buildGridMenu() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': "assets/icons/timtable.png", 
        'label': 'Timetable',
        'onTap': () {
          NavigationManager.navigateToFeatureScreen('Timetable', context);
        },
        'isEnlarged': true,
      },
      {
        'icon': "assets/icons/Attendance.png", 
        'label': 'Attendance',
        'onTap': () {
          NavigationManager.navigateToFeatureScreen('Attendance', context);
        },
        'isEnlarged': true,
      },
      {
        'icon': "assets/icons/Classroom.png", 
        'label': 'Class',
        'onTap': () {
          NavigationManager.navigateToFeatureScreen('Class', context);
        },
        'isEnlarged': true,
      },
      {
        'icon': "assets/icons/report_card.png", 
        'label': 'Report Card',
        'onTap': () {
          NavigationManager.navigateToFeatureScreen('Report Card', context);
        },
        'isEnlarged': true,
      },
      {
        'icon': "assets/icons/event.png", 
        'label': 'Event',
        'onTap': () {
          NavigationManager.navigateToFeatureScreen('Event', context);
        },
        'isEnlarged': true,
      },
      {
        'icon': "assets/icons/achivements.png", 
        'label': 'Achievement',
        'onTap': () {
          NavigationManager.navigateToFeatureScreen('Achievement', context);
        },
        'isEnlarged': true,
      },
      {
        'icon': "assets/icons/free.png", 
        'label': 'Fee',
        'onTap': () {
          NavigationManager.navigateToFeatureScreen('Fee', context);
        },
        'isEnlarged': true,
      },
      {
        'icon': "assets/icons/health.png", 
        'label': 'Health',
        'onTap': () {
          NavigationManager.navigateToFeatureScreen('Health', context);
        },
        'isEnlarged': true,
      },
    ];

    // Calculate the screen width and determine grid item width to avoid overflow
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 50) / 4;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 6 : 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.85,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 12.h,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
            // All items are now enlarged
            final bool isEnlarged = menuItems[index]['isEnlarged'] ?? true;
            final double iconSize = 32.w;
            final double containerSize = 66.w;
            
            return GestureDetector(
              onTap: menuItems[index]['onTap'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                    width: containerSize,
                    height: containerSize,
              decoration: BoxDecoration(
                  color: const Color(0xFF143460),
                      borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
          ),
        ],
      ),
                    child: Center(
                      child: Image.asset(
                        menuItems[index]['icon'], 
                        color: Colors.white,
                        width: iconSize,
                        height: iconSize,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white,
                            size: iconSize,
                          );
                        },
        ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    menuItems[index]['label'],
                    style: TextStyle(
                      fontSize: 14.sp,
          fontFamily: 'Arial',
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF13315C),
        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}
