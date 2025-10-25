import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/utils/navigation_manager.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample class data
  final List<Map<String, dynamic>> _classes = [
    {
      'subject': 'English',
      'teacher': 'Ms.Shas',
      'description': 'Note: Ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae vulputate diam, quis consectetur purus.',
      'homework': 'English Grammar',
      'dueDate': '15 Dec 2024',
    },
    {
      'subject': 'Mathematics',
      'teacher': 'Ms.Shas',
      'description': 'Note: Ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae vulputate diam, quis consectetur purus.',
      'homework': 'Multiplication',
      'dueDate': '15 Dec 2024',
    },
    {
      'subject': 'Science',
      'teacher': 'Ms.Shas',
      'description': 'Note: Ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae vulputate diam, quis consectetur purus.',
      'homework': 'Lab Reports',
      'dueDate': '15 Dec 2024',
    },
    {
      'subject': 'History',
      'teacher': 'Ms.Shas',
      'description': 'Note: Ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae vulputate diam, quis consectetur purus.',
      'homework': 'Research on Dinosaurs',
      'dueDate': '15 Dec 2024',
    },
    {
      'subject': 'ICT',
      'teacher': 'Ms.Shas',
      'description': 'Note: Ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae vulputate diam, quis consectetur purus.',
      'homework': 'Essay on Computers',
      'dueDate': '15 Dec 2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Class',
        showBackButton: true,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enrolled',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            // Class cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final classData = _classes[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildClassCard(
                    subject: classData['subject'],
                    teacher: classData['teacher'],
                    description: classData['description'],
                    homework: classData['homework'],
                    dueDate: classData['dueDate'],
                  ),
                );
              },
            ),
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

  Widget _buildClassCard({
    required String subject,
    required String teacher,
    required String description,
    required String homework,
    required String dueDate,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left side - Class info
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Teacher: $teacher',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            
            // Right side - Homework info
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF13315C),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Homework',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      homework,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Due Date: $dueDate',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 