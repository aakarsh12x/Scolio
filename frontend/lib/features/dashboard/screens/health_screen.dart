import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/utils/navigation_manager.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Health',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHealthCard(),
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

  Widget _buildHealthCard() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF13315C),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Name
          Text(
            'Student Name',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Health metrics grid (2x2)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.2,
            children: [
              _buildMetricCard('14', 'Age'),
              _buildMetricCard('A+', 'Blood Group'),
              _buildMetricCard('5\'1"', 'Height'),
              _buildMetricCard('51KG', 'Weight'),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // House Address
          _buildInfoCard(
            icon: Icons.home,
            title: 'House Address',
            content: 'No 01, Street 1/1, ABC City\n123456, XYZ State',
          ),
          
          SizedBox(height: 16.h),
          
          // Emergency Contact
          _buildInfoCard(
            icon: Icons.emergency,
            title: 'Emergency Contact',
            content: '+60123456789',
          ),
          
          SizedBox(height: 16.h),
          
          // Edit button
          Center(
            child: SizedBox(
              width: 150.w,
              child: ElevatedButton(
                onPressed: () {
                  // Edit functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: const Color(0xFF13315C),
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
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 