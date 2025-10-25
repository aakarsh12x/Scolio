import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _studentAttendance = {
    'Student A': true,
    'Student B': true,
    'Student C': true,
    'Student D': true,
    'Student E': true,
    'Student F': true,
    'Student G': true,
  };
  
  int _presentCount = 7;
  int _absentCount = 0;
  int _selectedPageIndex = 0;
  
  final List<String> _familyEmergencies = [
    'Student P',
    'Student Q',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Attendance',
        showBackButton: true,
        onLeadingPressed: () {
          Get.back();
        },
        actions: [
          IconButton(
            icon: Icon(
              Icons.print,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
            onPressed: () {
              Get.snackbar(
                'Print',
                'Printing attendance report',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.primaryColor,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      drawer: const TeacherDrawer(),
      body: Column(
        children: [
          _buildStatCards(),
          _buildPageIndicator(),
          _buildSearchBar(),
          Expanded(
            child: _selectedPageIndex == 0
                ? _buildAttendanceList()
                : _buildFamilyEmergenciesList(),
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

  Widget _buildStatCards() {
    return Container(
      height: 110.h,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D2545),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_presentCount',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Present Today',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_absentCount',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Absent Today',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D6E6E),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_familyEmergencies.length}',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'On Leave',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: _selectedPageIndex == 0
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 40.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: _selectedPageIndex == 1
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 24.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceList() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swipe left
          setState(() {
            _selectedPageIndex = 1;
          });
        }
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Student Name',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Attendance',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _studentAttendance.length,
              itemBuilder: (context, index) {
                final student = _studentAttendance.keys.elementAt(index);
                final isPresent = _studentAttendance[student]!;
                return _buildAttendanceItem(student, isPresent);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(String student, bool isPresent) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: isPresent ? AppColors.primaryColor : Colors.orange,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: Text(
              student,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final wasPresent = _studentAttendance[student]!;
                        _studentAttendance[student] = true;
                        if (!wasPresent) {
                          _presentCount++;
                          _absentCount--;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPresent
                          ? AppColors.primaryColor
                          : Colors.white,
                      side: isPresent
                          ? null
                          : BorderSide(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    child: Text(
                      'Present',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isPresent ? Colors.white : AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        final wasPresent = _studentAttendance[student]!;
                        _studentAttendance[student] = false;
                        if (wasPresent) {
                          _presentCount--;
                          _absentCount++;
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !isPresent ? Colors.orange : Colors.white,
                      side: BorderSide(
                        color: Colors.orange,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    child: Text(
                      'Absent',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: !isPresent ? Colors.white : Colors.orange,
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

  Widget _buildFamilyEmergenciesList() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swipe right
          setState(() {
            _selectedPageIndex = 0;
          });
        }
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _familyEmergencies.length,
        itemBuilder: (context, index) {
          final student = _familyEmergencies[index];
          return _buildFamilyEmergencyCard(student);
        },
      ),
    );
  }

  Widget _buildFamilyEmergencyCard(String student) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Family Emergency - $student',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      '9AM',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '10/01/2023',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Dear Parents,',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean posuere, orci eget eleifend malesuada, odio orci lacinia lacus, eu mollis augue enim sit amet mi. Duis efficitur et quam ut ultricies. Ut dignissim feugiat diam. Sed eget eleifend tellus, eget accumsan felis.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 1),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.snackbar(
                      'Approved',
                      'Leave has been approved for $student',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primaryColor,
                      colorText: Colors.white,
                    );
                  },
                  icon: Icon(
                    Icons.check,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Approve',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Get.snackbar(
                      'Rejected',
                      'Leave has been rejected for $student',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  },
                  icon: Icon(
                    Icons.close,
                    size: 18.sp,
                    color: Colors.red,
                  ),
                  label: Text(
                    'Reject',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                    side: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
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
} 