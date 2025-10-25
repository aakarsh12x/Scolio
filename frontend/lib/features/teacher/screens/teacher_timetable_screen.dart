import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/constants.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherTimetableScreen extends StatefulWidget {
  const TeacherTimetableScreen({Key? key}) : super(key: key);

  @override
  State<TeacherTimetableScreen> createState() => _TeacherTimetableScreenState();
}

class _TeacherTimetableScreenState extends State<TeacherTimetableScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _timetables = [
    {
      'period': 'March - November 2024',
      'file': null,
    },
    {
      'period': 'January - February 2024',
      'file': null,
    },
    {
      'period': 'June - December 2023',
      'file': null,
    },
    {
      'period': 'January - May 2023',
      'file': null,
    },
    {
      'period': 'April - December 2022',
      'file': null,
    },
  ];

  final List<Map<String, dynamic>> _subjects = [
    {
      'name': 'English',
      'startTime': '8:30 AM',
      'endTime': '9:15 AM',
    },
    {
      'name': 'Mathematics',
      'startTime': '8:30 AM',
      'endTime': '9:15 AM',
    },
    {
      'name': 'Science',
      'startTime': '8:30 AM',
      'endTime': '9:15 AM',
    },
    {
      'name': 'History',
      'startTime': '8:30 AM',
      'endTime': '9:15 AM',
    },
    {
      'name': 'ICT',
      'startTime': '8:30 AM',
      'endTime': '9:15 AM',
    },
    {
      'name': 'Economics',
      'startTime': '8:30 AM',
      'endTime': '9:15 AM',
    },
  ];

  String? _selectedFile;
  bool _isUploading = false;
  String? _selectedTimetable;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedTimetable = _timetables[0]['period'];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Timetable',
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRecentTimetableTab(),
                _buildCurrentTimetableTab(),
                _buildUploadTimetableTab(),
              ],
            ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: kPrimaryColor,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        indicatorColor: kPrimaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Recent Timetable'),
          Tab(text: 'Current Timetable'),
          Tab(text: 'Upload Timetable'),
        ],
      ),
    );
  }

  Widget _buildRecentTimetableTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(height: 20.h),
          Text(
            'Recent Timetable',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: _timetables.length,
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
                      _timetables[index]['period'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.edit,
                      color: kPrimaryColor,
                      size: 20.sp,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedTimetable = _timetables[index]['period'];
                        _tabController.animateTo(1);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                _tabController.animateTo(2);
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'New Timetable',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTimetableTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'March - November',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '2024',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: _subjects.map((subject) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subject['name'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                subject['startTime'],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                subject['endTime'],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (subject != _subjects.last)
                        Column(
                          children: [
                            SizedBox(height: 10.h),
                            Divider(),
                            SizedBox(height: 10.h),
                          ],
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update Timetable',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'To update the timetable, please upload the Excel, iCalendar or PDF file.',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _tabController.animateTo(2);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
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

  Widget _buildUploadTimetableTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUploadForm(),
          SizedBox(height: 24.h),
          _selectedFile != null ? _buildFilePreview() : _buildUploadPlaceholder(),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedFile = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade800,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
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
              ElevatedButton(
                onPressed: _selectedFile == null ? null : _handleSubmitTimetable,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  disabledBackgroundColor: Colors.grey.shade400,
                ),
                child: _isUploading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
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
    );
  }

  Widget _buildUploadForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Timetable For:',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: kPrimaryColor,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedTimetable,
              icon: Icon(Icons.arrow_drop_down, color: kPrimaryColor),
              items: _timetables.map((Map<String, dynamic> item) {
                return DropdownMenuItem<String>(
                  value: item['period'],
                  child: Text(item['period']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTimetable = newValue;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Upload Timetable',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: kPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _handleSelectFile,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedFile ?? 'Select a file to upload (Excel, PDF, iCalendar)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: _selectedFile != null ? Colors.black87 : Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.upload_file,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePreview() {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getFileIcon(),
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    _selectedFile ?? 'File Preview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getFileIcon(),
                    size: 64.sp,
                    color: kSecondaryColor.withOpacity(0.8),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'File ready to upload',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
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

  Widget _buildUploadPlaceholder() {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 64.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16.h),
            Text(
              'No file selected',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Select a file to upload',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon() {
    if (_selectedFile == null) return Icons.insert_drive_file;
    
    if (_selectedFile!.toLowerCase().endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (_selectedFile!.toLowerCase().endsWith('.xlsx') || 
              _selectedFile!.toLowerCase().endsWith('.xls')) {
      return Icons.table_chart;
    } else if (_selectedFile!.toLowerCase().endsWith('.ics')) {
      return Icons.event;
    }
    
    return Icons.insert_drive_file;
  }

  void _handleSelectFile() {
    // In a real app, you would use a file picker here
    setState(() {
      _selectedFile = 'March - November 2024.xlsx';
    });
  }

  void _handleSubmitTimetable() {
    setState(() {
      _isUploading = true;
    });

    // Simulate file upload
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isUploading = false;
        _selectedFile = null;
      });
      
      Get.snackbar(
        'Success',
        'Timetable uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kPrimaryColor,
        colorText: Colors.white,
      );
      
      _tabController.animateTo(0);
    });
  }
} 