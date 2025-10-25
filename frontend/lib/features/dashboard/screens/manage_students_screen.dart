import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:school_management/utils/navigation_manager.dart';

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({super.key});

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Student Name 1',
      'year': 'Year 1',
      'school': 'ABC Private School',
      'avatar': null,
      'isSelected': false,
    },
    {
      'name': 'Student Name 2',
      'year': 'Year 1',
      'school': 'ABC Private School',
      'avatar': null,
      'isSelected': false,
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Manage Students',
          showBackButton: true,
          onLeadingPressed: () {
            Get.offAll(() => const DashboardScreen());
          },
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: _buildSearchField(),
            ),
            Expanded(
              child: _buildStudentsList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddStudentDialog();
          },
          backgroundColor: const Color(0xFF13315C),
          child: const Icon(Icons.add, color: Colors.white),
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

  Widget _buildSearchField() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
        ),
        onChanged: (value) {
          // Implement search functionality here
        },
      ),
    );
  }

  Widget _buildStudentsList() {
    return ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: index % 2 == 0 ? Colors.blue[100] : Colors.orange[100],
                    child: student['avatar'] != null
                        ? Image.asset(
                            student['avatar'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              color: index % 2 == 0 ? Colors.blue[800] : Colors.orange[800],
                              size: 24.sp,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            color: index % 2 == 0 ? Colors.blue[800] : Colors.orange[800],
                            size: 24.sp,
                          ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${student['year']} | ${student['school']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: student['isSelected'],
                    activeColor: const Color(0xFF13315C),
                    onChanged: (value) {
                      setState(() {
                        student['isSelected'] = value;
                      });
                    },
                  ),
                ],
              ),
              Divider(color: Colors.grey[300]),
            ],
          ),
        );
      },
    );
  }

  void _showAddStudentDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController yearController = TextEditingController();
    final TextEditingController schoolController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text(
          'Add New Student',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF13315C),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: yearController,
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: schoolController,
                decoration: InputDecoration(
                  labelText: 'School Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  yearController.text.isNotEmpty &&
                  schoolController.text.isNotEmpty) {
                setState(() {
                  _students.add({
                    'name': nameController.text,
                    'year': yearController.text,
                    'school': schoolController.text,
                    'avatar': '',
                    'isSelected': false,
                  });
                });
                Get.back();
                Get.snackbar(
                  'Success',
                  'Student added successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Please fill all fields',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13315C),
            ),
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} 