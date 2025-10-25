import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/utils/navigation_manager.dart';

class ReportCardScreen extends StatefulWidget {
  const ReportCardScreen({super.key});

  @override
  State<ReportCardScreen> createState() => _ReportCardScreenState();
}

class _ReportCardScreenState extends State<ReportCardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedYear = 'Select Year';
  int _currentIndex = 2; // Calendar tab for bottom nav

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Report Card',
        showBackButton: true,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Year',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            _buildYearDropdown(),
            SizedBox(height: 24.h),
            Text(
              'Recently Uploaded',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: _buildReportsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          
          setState(() {
            _currentIndex = index;
          });
          
          if (index != _currentIndex) {
            NavigationManager.navigateFromBottomBar(index, context);
          }
        },
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedYear,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          elevation: 16,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedYear = newValue!;
            });
          },
          items: <String>['Select Year', '2024', '2023', '2022', '2021']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    final reports = [
      'Jan Trial Exam',
      'Multiplication Test',
      'ICT Report Result',
      'Mid-Term Exam Result',
    ];

    return ListView.separated(
      itemCount: reports.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        height: 1,
      ),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          title: Text(
            reports[index],
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.download_outlined,
              color: Colors.grey.shade700,
              size: 24.sp,
            ),
            onPressed: () {
              Get.snackbar(
                'Download',
                'Downloading ${reports[index]}...',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF134074),
                colorText: Colors.white,
              );
            },
          ),
        );
      },
    );
  }
} 