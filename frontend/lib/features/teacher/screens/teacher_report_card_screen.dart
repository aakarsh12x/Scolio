import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherReportCardScreen extends StatefulWidget {
  const TeacherReportCardScreen({Key? key}) : super(key: key);

  @override
  State<TeacherReportCardScreen> createState() => _TeacherReportCardScreenState();
}

class _TeacherReportCardScreenState extends State<TeacherReportCardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  final TextEditingController _reportTitleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String? _selectedStudent;
  String? _selectedYear;
  
  final List<String> _students = [
    'Student A',
    'Student B',
    'Student C',
    'Student D',
    'Student E',
    'Student F',
    'Student G',
  ];

  final List<String> _years = [
    '2024',
    '2023',
    '2022',
    '2021',
  ];

  final List<Map<String, String>> _reportHistory = [
    {
      'student': 'Student A',
      'title': 'Jan Trial Exam',
      'year': '2024',
    },
    {
      'student': 'Student A',
      'title': 'ICT Report',
      'year': '2024',
    },
    {
      'student': 'Student Y',
      'title': 'Jan Trial Exam',
      'year': '2024',
    },
    {
      'student': 'Student C',
      'title': 'Jan Trial Exam',
      'year': '2024',
    },
    {
      'student': 'Student E',
      'title': 'Jan Trial Exam',
      'year': '2024',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = _years.first;
    _yearController.text = _selectedYear!;
  }

  @override
  void dispose() {
    _reportTitleController.dispose();
    _yearController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Report Card',
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
                  'Report History',
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
                  'Upload Report',
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
      return _buildReportHistoryTab();
    } else {
      return _buildUploadReportTab();
    }
  }

  Widget _buildReportHistoryTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Year',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
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
            value: _selectedYear,
            onChanged: (String? newValue) {
              setState(() {
                _selectedYear = newValue;
              });
            },
            items: _years.map<DropdownMenuItem<String>>((String value) {
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
            'Report History',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: _reportHistory.length,
              itemBuilder: (context, index) {
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
                      '${_reportHistory[index]['student']} - ${_reportHistory[index]['title']}',
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
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 1;
                        _selectedStudent = _reportHistory[index]['student'];
                        _reportTitleController.text = _reportHistory[index]['title'] ?? '';
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadReportTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Title',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _reportTitleController,
              decoration: InputDecoration(
                hintText: 'Enter Trial Exam',
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
              'Enter Year',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                _showYearPicker(context);
              },
              child: TextField(
                controller: _yearController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Enter Year',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Student',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200.h,
                    child: ListView.builder(
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        return CheckboxListTile(
                          title: Text(student),
                          value: _selectedStudent == student,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedStudent = student;
                              } else {
                                _selectedStudent = null;
                              }
                            });
                          },
                          activeColor: AppColors.primaryColor,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Upload Report',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            _buildUploadField('Jan Trial Exam - PDF'),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                      'Success',
                      'Report uploaded successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primaryColor,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadField(String hintText) {
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
                hintText,
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

  void _showYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      builder: (BuildContext bc) {
        return Container(
          height: 250.h,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  'Select Year',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _years.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _years[index],
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: _years[index] == _selectedYear
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _years[index] == _selectedYear
                              ? AppColors.primaryColor
                              : Colors.black,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedYear = _years[index];
                          _yearController.text = _selectedYear!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 