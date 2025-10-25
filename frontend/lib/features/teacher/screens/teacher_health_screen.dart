import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherHealthScreen extends StatefulWidget {
  const TeacherHealthScreen({Key? key}) : super(key: key);

  @override
  State<TeacherHealthScreen> createState() => _TeacherHealthScreenState();
}

class _TeacherHealthScreenState extends State<TeacherHealthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String selectedStudent = 'Select Student';
  final List<String> students = [
    'Student A',
    'Student B',
    'Student C',
    'Student D',
    'Student E',
    'Student F',
    'Student G',
    'Student H',
  ];
  
  // Whether to show the detailed health view
  bool showDetailedView = false;
  String detailedViewStudent = '';
  
  // Flag to control student selector visibility
  bool showStudentSelector = false;
  
  // Recently checked students
  final List<String> recentlyChecked = [
    'Student A',
    'Student B',
    'Student C',
    'Student D',
    'Student E',
    'Student F',
    'Student G',
  ];
  
  // Sample health data
  final Map<String, Map<String, dynamic>> healthData = {
    'Student A': {
      'age': '14',
      'blood_group': 'A+',
      'height': '5\'1\"',
      'weight': '51KG',
      'address': 'No 01, Street 1/1, ABC City, 123456, XYZ State.',
      'emergency_contact': '+60123456789',
    },
    'Student B': {
      'age': '15',
      'blood_group': 'B+',
      'height': '5\'4\"',
      'weight': '55KG',
      'address': 'No 02, Street 2/2, ABC City, 123456, XYZ State.',
      'emergency_contact': '+60123456780',
    },
    'Student C': {
      'age': '14',
      'blood_group': 'O+',
      'height': '5\'2\"',
      'weight': '48KG',
      'address': 'No 03, Street 3/3, ABC City, 123456, XYZ State.',
      'emergency_contact': '+60123456781',
    },
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Health',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF13315C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF13315C)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF13315C)),
            onPressed: () {},
          ),
        ],
      ),
      body: showDetailedView 
        ? _buildDetailedHealthView(detailedViewStudent)
        : _buildStudentListView(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: NavigationManager.currentBottomNavIndex,
        onTap: (index) {
          NavigationManager.navigateFromBottomBar(index, context);
        },
      ),
    );
  }
  
  Widget _buildStudentListView() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: DropdownButton<String>(
              value: selectedStudent,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: const SizedBox(),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
              ),
              onChanged: (String? newValue) {
                if (newValue != 'Select Student') {
                  setState(() {
                    showDetailedView = true;
                    detailedViewStudent = newValue!;
                  });
                }
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'Select Student',
                  child: Text(
                    'Select Student',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                ...students.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Recently Checked
          Text(
            'Recently Checked',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Student List
          Expanded(
            child: ListView.builder(
              itemCount: recentlyChecked.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      showDetailedView = true;
                      detailedViewStudent = recentlyChecked[index];
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      recentlyChecked[index],
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailedHealthView(String student) {
    // If we don't have data for this student, show a placeholder
    final healthInfo = healthData[student] ?? {
      'age': '14',
      'blood_group': 'O+',
      'height': '5\'3\"',
      'weight': '50KG',
      'address': 'No 01, Main Street, ABC City, 123456, XYZ State.',
      'emergency_contact': '+60123456789',
    };
    
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student selector with dropdown button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B2545),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Student: $student',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showStudentSelector = !showStudentSelector;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              child: Icon(
                                showStudentSelector ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              
              // Health Information Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2545),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        // Age
                        Expanded(
                          child: Container(
                            height: 100.h,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  healthInfo['age'] ?? '',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Age',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Blood Group
                        Expanded(
                          child: Container(
                            height: 100.h,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  healthInfo['blood_group'] ?? '',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Blood Group',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        // Height
                        Expanded(
                          child: Container(
                            height: 100.h,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  healthInfo['height'] ?? '',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Height',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Weight
                        Expanded(
                          child: Container(
                            height: 100.h,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  healthInfo['weight'] ?? '',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C4B82),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'House Address',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                healthInfo['address'] ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Emergency Contact
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C4B82),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.emergency,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Contact',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                healthInfo['emergency_contact'] ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Student selector popup - Only show when toggled
        if (showStudentSelector)
          Positioned(
            top: 64.h, // Positioned below the header
            left: 16.w,
            right: 16.w,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: students.map((studentName) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        detailedViewStudent = studentName;
                        showStudentSelector = false; // Hide selector after selection
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            studentName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                          if (studentName == detailedViewStudent)
                            Container(
                              width: 16.w,
                              height: 16.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF13315C),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
} 