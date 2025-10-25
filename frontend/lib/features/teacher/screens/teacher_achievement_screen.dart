import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherAchievementScreen extends StatefulWidget {
  const TeacherAchievementScreen({Key? key}) : super(key: key);

  @override
  State<TeacherAchievementScreen> createState() => _TeacherAchievementScreenState();
}

class _TeacherAchievementScreenState extends State<TeacherAchievementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  String? _selectedStudent;
  final TextEditingController _eventTitleController = TextEditingController();
  
  final List<String> _students = [
    'Student A',
    'Student B',
    'Student C',
    'Student D',
    'Student E',
    'Student F',
    'Student G',
  ];

  final List<Map<String, String>> _recentAchievements = [
    {
      'title': 'Best Goal Scorer - Student A',
      'image': 'assets/images/trophy.png',
      'date': '2024-05-15',
    },
    {
      'title': 'Music Competition - Student A',
      'image': 'assets/images/music.png',
      'date': '2024-04-10',
    },
  ];

  @override
  void dispose() {
    _eventTitleController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Achievements',
        showBackButton: true,
        onLeadingPressed: () {
          Get.back();
        },
      ),
      drawer: const TeacherDrawer(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildSelectedTabContent(),
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

  Widget _buildTabBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTabIndex == 0
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Text(
                  'Recently Uploaded',
                  style: TextStyle(
                    color: _selectedTabIndex == 0
                        ? AppColors.primaryColor
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTabIndex == 1
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Text(
                  'Upload Achievement',
                  style: TextStyle(
                    color: _selectedTabIndex == 1
                        ? AppColors.primaryColor
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    if (_selectedTabIndex == 0) {
      return _buildRecentAchievementsTab();
    } else {
      return _buildUploadAchievementTab();
    }
  }

  Widget _buildRecentAchievementsTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            value: 'Student A - Physics',
            onChanged: (String? newValue) {},
            items: ['Student A - Physics', 'Student B - Chemistry'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Recently Uploaded',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index < _recentAchievements.length) {
                  return _buildAchievementCard(_recentAchievements[index]);
                } else {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Student ${String.fromCharCode(65 + index)} - ${index % 2 == 0 ? 'Competition' : 'Award Certificate'}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        Icons.edit,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                      onTap: () {},
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, String> achievement) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          achievement['title']!,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: Icon(
          Icons.edit,
          color: AppColors.primaryColor,
          size: 20.sp,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildUploadAchievementTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Title',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _eventTitleController,
              decoration: InputDecoration(
                hintText: 'Enter title here',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                suffixIcon: Icon(Icons.text_fields, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Upload Certificate to:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                _buildStudentOption('All Students'),
                SizedBox(width: 10.w),
                _buildStudentOption('Specific Student'),
              ],
            ),
            SizedBox(height: 20.h),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Select Student',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
              value: _selectedStudent,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStudent = newValue;
                });
              },
              items: _students.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),
            Text(
              'Upload Certificate',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            _buildUploadField(),
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: _recentAchievements.isNotEmpty
                  ? _buildCertificatePreview()
                  : SizedBox(
                      height: 180.h,
                      child: Center(
                        child: Text(
                          'Certificate preview will appear here',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 24.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Success',
                    'Certificate uploaded successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primaryColor,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentOption(String title) {
    bool isSelected = title == 'Specific Student';
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Radio(
              value: title,
              groupValue: 'Specific Student',
              onChanged: (value) {},
              activeColor: AppColors.primaryColor,
            ),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Click to upload',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            Icon(
              Icons.upload_file,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificatePreview() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              topRight: Radius.circular(8.r),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Best Goal Scorer - Student A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 50.sp,
                  color: Colors.amber,
                ),
                SizedBox(height: 8.h),
                Text(
                  'BEST GOALSCORER\nCERTIFICATE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.r),
              bottomRight: Radius.circular(8.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Awarded to: Student A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.share, color: Colors.white, size: 18.sp),
                  SizedBox(width: 12.w),
                  Icon(Icons.fullscreen, color: Colors.white, size: 18.sp),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
} 