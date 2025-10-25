import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/utils/navigation_manager.dart';
import 'package:get/get.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Set the bottom nav index for News
    NavigationManager.currentBottomNavIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const DashboardScreen());
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          title: 'News',
          showBackButton: true,
          onLeadingPressed: () {
            Get.offAll(() => const DashboardScreen());
          },
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeaturedNews(),
              SizedBox(height: 24.h),
              _buildNewsList(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: NavigationManager.currentBottomNavIndex,
          onTap: (index) {
            NavigationManager.navigateFromBottomBar(index, context);
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedNews() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            "assets/images/News.png",
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                SizedBox(height: 8.h),
                Text(
                  'Annual School Sports Day - Coming Soon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Join us for a day of sports and fun!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsList() {
    final List<Map<String, dynamic>> newsList = [
      {
        'title': 'Parent-Teacher Meeting',
        'date': 'July 20, 2024',
        'description': 'Discuss your child\'s progress with their teachers.',
        'image': 'assets/images/News.png',
        'tag': 'EVENT',
        'tagColor': Colors.blue,
      },
      {
        'title': 'School Holiday Announcement',
        'date': 'July 18, 2024',
        'description': 'School will be closed for Independence Day celebrations.',
        'image': 'assets/images/News.png',
        'tag': 'HOLIDAY',
        'tagColor': Colors.orange,
      },
      {
        'title': 'Science Fair Registration Open',
        'date': 'July 15, 2024',
        'description': 'Register your projects for the upcoming Science Fair.',
        'image': 'assets/images/News.png',
        'tag': 'ACADEMIC',
        'tagColor': Colors.green,
      },
      {
        'title': 'Library Book Return Reminder',
        'date': 'July 10, 2024',
        'description': 'Please return any borrowed books by the end of the month.',
        'image': 'assets/images/News.png',
        'tag': 'REMINDER',
        'tagColor': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest News',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF134074),
          ),
        ),
        SizedBox(height: 16.h),
        ...newsList.map((news) => _buildNewsItem(
              news['title'],
              news['date'],
              news['description'],
              news['image'],
              news['tag'],
              news['tagColor'],
            )),
      ],
    );
  }

  Widget _buildNewsItem(
    String title,
    String date,
    String description,
    String image,
    String tag,
    Color tagColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: tagColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: tagColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
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
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(60.w, 32.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Read More',
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
} 