import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherHomeworkScreen extends StatefulWidget {
  final String subjectName;
  final String teacherName;
  final String grade;
  
  const TeacherHomeworkScreen({
    Key? key, 
    required this.subjectName,
    required this.teacherName,
    required this.grade,
  }) : super(key: key);

  @override
  State<TeacherHomeworkScreen> createState() => _TeacherHomeworkScreenState();
}

class _TeacherHomeworkScreenState extends State<TeacherHomeworkScreen> {
  final TextEditingController _homeworkTitleController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  bool _allStudentsSelected = true;
  bool _specificStudentSelected = false;
  
  // List of students for the dropdown
  final List<String> _students = [
    'Student A',
    'Student B',
    'Student C',
    'Student D',
    'Student E',
    'Student F',
    'Student G',
    'Student H',
  ];
  
  // Selected students
  List<String> _selectedStudents = [];
  String? _selectedStudent;
  
  @override
  void initState() {
    super.initState();
    NavigationManager.isTeacherMode = true;
    NavigationManager.currentBottomNavIndex = 1; // Classes tab
  }
  
  @override
  void dispose() {
    _homeworkTitleController.dispose();
    _dueDateController.dispose();
    _noteController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              widget.subjectName,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 20.h),
            _buildHomeworkTitleField(),
            SizedBox(height: 16.h),
            _buildAssignToSection(),
            SizedBox(height: 16.h),
            _buildDueDateField(),
            SizedBox(height: 16.h),
            _buildNoteField(),
            SizedBox(height: 24.h),
            _buildSubmitButton(),
            SizedBox(height: 16.h),
          ],
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
  
  Widget _buildHomeworkTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Homework Title',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _homeworkTitleController,
          decoration: InputDecoration(
            hintText: 'Enter the Title',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
            suffixIcon: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.text_fields,
                  color: Colors.grey,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAssignToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assign Homework to:',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: _allStudentsSelected,
              onChanged: (value) {
                setState(() {
                  _allStudentsSelected = true;
                  _specificStudentSelected = false;
                });
              },
              visualDensity: VisualDensity.compact,
              activeColor: AppColors.primaryColor,
            ),
            Text(
              'All Student',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 24.w),
            Radio<bool>(
              value: true,
              groupValue: _specificStudentSelected,
              onChanged: (value) {
                setState(() {
                  _allStudentsSelected = false;
                  _specificStudentSelected = true;
                });
              },
              visualDensity: VisualDensity.compact,
              activeColor: AppColors.primaryColor,
            ),
            Text(
              'Specific Student',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        if (_specificStudentSelected)
          Container(
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStudent,
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Select Student',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                items: _students.map((student) {
                  return DropdownMenuItem<String>(
                    value: student,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: _selectedStudents.contains(student),
                            groupValue: true,
                            onChanged: (value) {},
                            visualDensity: VisualDensity.compact,
                            activeColor: AppColors.primaryColor,
                          ),
                          SizedBox(width: 8.w),
                          Text(student),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStudent = value;
                      if (!_selectedStudents.contains(value)) {
                        _selectedStudents.add(value);
                      } else {
                        _selectedStudents.remove(value);
                      }
                    });
                  }
                },
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildDueDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _dueDateController,
          readOnly: true,
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primaryColor,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            
            if (pickedDate != null) {
              setState(() {
                _dueDateController.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Insert the Due Date',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Colors.grey,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Write a Note',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
            suffixIcon: Icon(
              Icons.text_fields,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSubmitButton() {
    return Center(
      child: Container(
        width: 180.w,
        height: 45.h,
        child: ElevatedButton(
          onPressed: () {
            // Handle homework submission
            Get.back();
            Get.snackbar(
              'Success',
              'Homework has been assigned successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Submit',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
} 