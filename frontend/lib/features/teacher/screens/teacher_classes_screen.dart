import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/features/teacher/screens/teacher_homework_list_screen.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/navigation_manager.dart';
import 'package:school_management/utils/app_screen_type.dart';

class TeacherClassesScreen extends StatefulWidget {
  const TeacherClassesScreen({Key? key}) : super(key: key);

  @override
  State<TeacherClassesScreen> createState() => _TeacherClassesScreenState();
}

class _TeacherClassesScreenState extends State<TeacherClassesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> _classes = [
    {
      'subject': 'English',
      'teacher': 'Ms. Shaw',
      'grade': 'Year 10',
      'timeSlot': '08:30 AM - 09:15 AM',
      'description': 'English Grammar and Literature',
      'students': 34,
      'nextHomework': 'No Homework',
    },
    {
      'subject': 'Mathematics',
      'teacher': 'Ms. Shaw',
      'grade': 'Year 11',
      'timeSlot': '09:30 AM - 10:15 AM',
      'description': 'Quadratic Equations and Algebra',
      'students': 32,
      'nextHomework': 'No Homework',
    },
    {
      'subject': 'Science',
      'teacher': 'Ms. Shaw',
      'grade': 'Year 9',
      'timeSlot': '10:30 AM - 11:15 AM',
      'description': 'Chemistry Basics and Lab Work',
      'students': 36,
      'nextHomework': 'No Homework',
    },
    {
      'subject': 'History',
      'teacher': 'Ms. Shaw',
      'grade': 'Year 10',
      'timeSlot': '11:30 AM - 12:15 PM',
      'description': 'World War II and its Impact',
      'students': 33,
      'nextHomework': 'No Homework',
    },
    {
      'subject': 'ICT',
      'teacher': 'Ms. Shaw',
      'grade': 'Year 9',
      'timeSlot': '01:30 PM - 02:15 PM',
      'description': 'Basic Computing and Internet',
      'students': 30,
      'nextHomework': 'No Homework',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Mark as a feature screen
    NavigationManager.currentScreenType = AppScreenType.feature;
    // Don't change the bottom nav index if coming from dashboard
    // This allows us to keep the Home tab selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Class',
        showBackButton: false,
        onLeadingPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: const TeacherDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Enrolled',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: _buildClassList(),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: NavigationManager.currentBottomNavIndex,
        onTap: (index) {
          NavigationManager.navigateFromBottomBar(index, context);
        },
        isTeacherMode: true,
      ),
    );
  }

  Widget _buildClassList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _classes.length,
      itemBuilder: (context, index) {
        final classData = _classes[index];
        return _buildClassCard(classData);
      },
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classData) {
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
      child: InkWell(
        onTap: () {
          // Navigate to homework list screen for this class
          Get.to(() => TeacherHomeworkListScreen(
                subjectName: classData['subject'],
                teacherName: classData['teacher'],
                grade: classData['grade'],
              ));
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classData['subject'],
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Teacher: ${classData['teacher']}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      classData['grade'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      classData['timeSlot'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${classData['students']} students',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Icon(
                          Icons.assignment,
                          size: 14.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          classData['nextHomework'],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 60.w,
              height: 130.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.assignment,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 