import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/screens/teacher_event_detail_screen.dart';
import 'package:school_management/utils/navigation_manager.dart';

class TeacherEventScreen extends StatefulWidget {
  const TeacherEventScreen({Key? key}) : super(key: key);

  @override
  State<TeacherEventScreen> createState() => _TeacherEventScreenState();
}

class _TeacherEventScreenState extends State<TeacherEventScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Dummy data for events
  final List<Map<String, dynamic>> events = [
    {
      'title': 'Family Day Out',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac sem vitae enim imperdiet sollicitudin. Integer quis nunc finibus, scelerisque nisi eget, tristique tellus.',
      'date': 'Monday, 01/01/2024',
      'image': 'assets/images/News.png', // Placeholder image
    },
    {
      'title': 'Family Marathon',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac sem vitae enim imperdiet sollicitudin. Integer quis nunc finibus, scelerisque nisi eget, tristique tellus.',
      'date': 'Monday, 01/01/2024',
      'image': 'assets/images/News.png', // Placeholder image
    },
    {
      'title': 'Singing Competition',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac sem vitae enim imperdiet sollicitudin. Integer quis nunc finibus, scelerisque nisi eget, tristique tellus.',
      'date': 'Monday, 01/01/2024',
      'image': 'assets/images/News.png', // Placeholder image
    },
  ];
  
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
          'Event',
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
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventCard(event);
            },
          ),
          
          // Add Event Button
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: FloatingActionButton(
              onPressed: () {
                _showAddEventDialog(context);
              },
              backgroundColor: const Color(0xFF13315C),
              child: const Icon(Icons.add, color: Colors.white),
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
  
  Widget _buildEventCard(Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () {
        // Navigate to event detail screen
        Get.to(() => TeacherEventDetailScreen(
          title: event['title'],
          date: event['date'],
          imageUrl: event['image'],
          description: event['description'],
        ));
      },
      child: Container(
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
        ),
        child: Row(
          children: [
            // Left part - Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: Image.asset(
                event['image'],
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120.w,
                    height: 120.h,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
            
            // Right part - Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event['title'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _showEditEventDialog(context, event);
                          },
                          child: Icon(
                            Icons.edit,
                            size: 18.sp,
                            color: const Color(0xFF13315C),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      event['description'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          'Event Day',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          event['date'],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blue,
                          ),
                        ),
                      ],
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
  
  // Dialog to add a new event
  void _showAddEventDialog(BuildContext context) {
    Get.dialog(
      _buildEventDialog(
        title: 'Add Event',
        isEditMode: false,
        event: {
          'title': '',
          'date': '',
          'description': '',
          'brochurePath': '',
        },
      ),
    );
  }
  
  // Dialog to edit an existing event
  void _showEditEventDialog(BuildContext context, Map<String, dynamic> event) {
    Get.dialog(
      _buildEventDialog(
        title: 'Edit Event',
        isEditMode: true,
        event: event,
      ),
    );
  }
  
  // Common dialog builder for add and edit
  Widget _buildEventDialog({
    required String title,
    required bool isEditMode,
    required Map<String, dynamic> event,
  }) {
    final TextEditingController titleController = TextEditingController(text: event['title']);
    final TextEditingController dateController = TextEditingController(text: event['date']?.toString().replaceAll('Monday, ', '') ?? '');
    final TextEditingController noteController = TextEditingController(text: event['description']);
    final TextEditingController brochureController = TextEditingController(text: event['brochurePath'] ?? '');
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        width: 0.9.sw,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF13315C),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Color(0xFF13315C)),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Event Title
            Text(
              'Event Title',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter Event Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                suffixIcon: const Icon(Icons.text_fields),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Event Date
            Text(
              'Event Date',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                hintText: 'Insert the Event Day',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () async {
                // Date picker could be implemented here
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            SizedBox(height: 16.h),
            
            // Note
            Text(
              'Note',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write a Note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                suffixIcon: const Icon(Icons.text_fields),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Upload Brochure
            Text(
              'Upload Brochure',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: brochureController,
              decoration: InputDecoration(
                hintText: 'Upload the Brochure',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                suffixIcon: const Icon(Icons.attach_file),
              ),
              onTap: () {
                // File picker could be implemented here
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            SizedBox(height: 24.h),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Save the event data
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13315C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                  ),
                  child: const Text('Submit'),
                ),
                if (isEditMode) ...[
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      // Delete the event
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
} 