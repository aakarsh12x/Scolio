import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/screens/teacher_homework_screen.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherHomeworkListScreen extends StatefulWidget {
  final String subjectName;
  final String teacherName;
  final String grade;
  
  const TeacherHomeworkListScreen({
    Key? key, 
    required this.subjectName,
    required this.teacherName,
    required this.grade,
  }) : super(key: key);

  @override
  State<TeacherHomeworkListScreen> createState() => _TeacherHomeworkListScreenState();
}

class _TeacherHomeworkListScreenState extends State<TeacherHomeworkListScreen> {
  // Dummy homework data
  final List<Map<String, dynamic>> _homeworkList = [
    {
      'title': 'Grammar Exercise',
      'dueDate': '20/06/2024',
      'assignedTo': 'All Students',
      'status': 'Open',
    },
    {
      'title': 'Reading Assignment',
      'dueDate': '25/06/2024',
      'assignedTo': 'Student A, Student B',
      'status': 'Open',
    },
    {
      'title': 'Essay Writing',
      'dueDate': '15/06/2024',
      'assignedTo': 'All Students',
      'status': 'Closed',
    },
  ];

  @override
  void initState() {
    super.initState();
    NavigationManager.isTeacherMode = true;
    NavigationManager.currentBottomNavIndex = 1; // Classes tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Homework',
        showBackButton: true,
        onLeadingPressed: () {
          Get.back();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClassHeader(),
          Expanded(
            child: _buildHomeworkList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => TeacherHomeworkScreen(
                subjectName: widget.subjectName,
                teacherName: widget.teacherName,
                grade: widget.grade,
              ));
        },
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 24.sp,
        ),
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
  
  Widget _buildClassHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.subjectName,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            widget.grade,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Teacher: ${widget.teacherName}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHomeworkList() {
    if (_homeworkList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              'No Homework Assigned',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Click the + button to assign new homework',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _homeworkList.length,
      itemBuilder: (context, index) {
        final homework = _homeworkList[index];
        return _buildHomeworkCard(homework);
      },
    );
  }
  
  Widget _buildHomeworkCard(Map<String, dynamic> homework) {
    final bool isOpen = homework['status'] == 'Open';
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isOpen ? Colors.blue.withOpacity(0.1) : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  homework['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isOpen ? AppColors.primaryColor : Colors.grey[600],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isOpen ? AppColors.primaryColor : Colors.grey[400],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    homework['status'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildInfoRow('Due Date', homework['dueDate']),
                SizedBox(height: 8.h),
                _buildInfoRow('Assigned To', homework['assignedTo']),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      'Edit',
                      Icons.edit,
                      AppColors.primaryColor,
                      () {
                        // Edit homework
                      },
                    ),
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      isOpen ? 'Close' : 'Reopen',
                      isOpen ? Icons.check_circle : Icons.refresh,
                      isOpen ? Colors.green : Colors.orange,
                      () {
                        // Toggle status
                        setState(() {
                          homework['status'] = isOpen ? 'Closed' : 'Open';
                        });
                      },
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
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16.sp,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        elevation: 0,
      ),
    );
  }
} 