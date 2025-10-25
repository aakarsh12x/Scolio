import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/utils/navigation_manager.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Achievement',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCertificateCard(
                title: 'Best Goalkeeper',
                certificateImage: _buildSoccerCertificate(),
              ),
              SizedBox(height: 16.h),
              _buildCertificateCard(
                title: 'Music Competition',
                certificateImage: _buildMusicCertificate(),
              ),
            ],
          ),
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

  Widget _buildCertificateCard({
    required String title,
    required Widget certificateImage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Certificate Title Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFF13315C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          // Certificate Content
          certificateImage,
          
          // Action Buttons
          Row(
            children: [
              // Download Button
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Download certificate
                    Get.snackbar(
                      'Download',
                      'Downloading $title certificate...',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF13315C),
                      colorText: Colors.white,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: const BoxDecoration(
                      color: Color(0xFF13315C),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Share Button
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Share certificate
                    Get.snackbar(
                      'Share',
                      'Sharing $title certificate...',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF8E9AAF),
                      colorText: Colors.white,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8E9AAF),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Share',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoccerCertificate() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Medal Image
              Container(
                width: 60.w,
                height: 90.h,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.sports_soccer,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 15.w,
                      child: Container(
                        width: 30.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            topRight: Radius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Logo & Text
              Column(
                children: [
                  Text(
                    'Scolio',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF13315C),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'BEST GOALKEEPER',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'CERTIFICATE',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              
              // Trophy Image
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 36.sp,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Divider Line
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          
          SizedBox(height: 16.h),
          
          // Student Text
          Text(
            'Student',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Certificate Description
          Text(
            'This certificate recognizes your exceptional skill and dedication shown during the annual school football tournament. Your outstanding performance as goalkeeper has earned you this recognition.',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 16.h),
          
          // Soccer Field
          Container(
            height: 60.h,
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 20.w,
                  child: Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20.w,
                  child: Container(
                    width: 40.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicCertificate() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.lightBlue.withOpacity(0.1),
      ),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          
          // Music Notes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMusicInstrument(Icons.music_note, Colors.blue),
              _buildMusicInstrument(Icons.piano, Colors.blue),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Award Title
          Text(
            'MUSIC AWARD',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'This certificate is awarded to',
            style: TextStyle(
              fontSize: 12.sp,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Student Name
          Text(
            'Student A',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Certificate Description
          Text(
            'This certificate recognizes your exceptional talent and dedication shown during the regional music competition. Your outstanding performance has earned you this recognition.',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 16.h),
          
          // More Music Notes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMusicInstrument(Icons.music_note, Colors.blue),
              _buildMusicInstrument(Icons.queue_music, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildMusicInstrument(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24.sp,
      ),
    );
  }
} 