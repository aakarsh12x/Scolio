import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/utils/navigation_manager.dart';
import 'package:school_management/components/safe_back_screen.dart';
import 'package:school_management/utils/app_screen_type.dart';

class TeacherNewsScreen extends StatefulWidget {
  const TeacherNewsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherNewsScreen> createState() => _TeacherNewsScreenState();
}

class _TeacherNewsScreenState extends State<TeacherNewsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // View modes
  bool showDetailedView = false;
  bool showEditView = false;
  bool showAddView = false;
  
  Map<String, dynamic>? selectedNews;
  
  // Dummy news data
  final List<Map<String, dynamic>> newsList = [
    {
      'title': 'News Title 1',
      'date': 'Monday, 01/01/2024',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac sem vitae enim imperdiet sollicitudin. Integer quis nunc finibus, scelerisque nisi eget, tristique tellus.',
      'image': 'assets/images/News.png', // Placeholder image
    },
    {
      'title': 'News Title 2',
      'date': 'Monday, 01/01/2024',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac sem vitae enim imperdiet sollicitudin. Integer quis nunc finibus, scelerisque nisi eget, tristique tellus.',
      'image': 'assets/images/News.png', // Placeholder image
    },
    {
      'title': 'News Title 3',
      'date': 'Monday, 01/01/2024',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac sem vitae enim imperdiet sollicitudin. Integer quis nunc finibus, scelerisque nisi eget, tristique tellus.',
      'image': 'assets/images/News.png', // Placeholder image
    },
  ];
  
  // Controllers for text editing
  late TextEditingController titleController;
  late TextEditingController dateController;
  late TextEditingController descriptionController;
  late TextEditingController brochureController;

  @override
  void initState() {
    super.initState();
    // Don't change the navigation index, just mark as feature screen
    // This ensures we maintain the original selected tab in the bottom nav bar
    NavigationManager.currentScreenType = AppScreenType.feature;
    
    titleController = TextEditingController();
    dateController = TextEditingController();
    descriptionController = TextEditingController();
    brochureController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    brochureController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    
    if (showDetailedView && selectedNews != null) {
      bodyContent = _buildNewsDetailView();
    } else if (showEditView) {
      bodyContent = _buildEditNewsView();
    } else if (showAddView) {
      bodyContent = _buildAddNewsView();
    } else {
      bodyContent = _buildNewsListView();
    }
    
    return SafeBackScreen(
      title: 'News',
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'News',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF13315C),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF13315C)),
            onPressed: () {
              if (showDetailedView || showEditView || showAddView) {
                setState(() {
                  showDetailedView = false;
                  showEditView = false;
                  showAddView = false;
                  selectedNews = null;
                });
              } else {
                Get.back();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Color(0xFF13315C)),
              onPressed: () {},
            ),
          ],
        ),
        body: bodyContent,
        floatingActionButton: !showDetailedView && !showEditView && !showAddView
            ? FloatingActionButton(
                backgroundColor: const Color(0xFF13315C),
                onPressed: () {
                  setState(() {
                    showAddView = true;
                    titleController.clear();
                    dateController.clear();
                    descriptionController.clear();
                    brochureController.clear();
                  });
                },
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        bottomNavigationBar: SharedBottomNavBar(
          currentIndex: NavigationManager.currentBottomNavIndex,
          onTap: (index) {
            NavigationManager.navigateFromBottomBar(index, context);
          },
          isTeacherMode: true,
        ),
      ),
    );
  }
  
  Widget _buildNewsListView() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return _buildNewsCard(news, index);
      },
    );
  }
  
  Widget _buildNewsCard(Map<String, dynamic> news, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left part - Image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                ),
                child: Image.asset(
                  news['image'],
                  width: 110.w,
                  height: 110.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110.w,
                      height: 110.h,
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
                              news['title'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showEditView = true;
                                selectedNews = news;
                                titleController.text = news['title'];
                                dateController.text = news['date'];
                                descriptionController.text = news['description'];
                              });
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
                        news['description'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        news['date'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildNewsDetailView() {
    final news = selectedNews!;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image
          Container(
            width: double.infinity,
            height: 240.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Image.asset(
              news['image'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image,
                    size: 80.sp,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'News A',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '01/01/2024',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Dear Parents,',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${news['description']}\n\n'
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditNewsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit News',
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
          
          // News Title
          Text(
            'News Title',
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
              hintText: 'Enter News Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              suffixIcon: const Icon(Icons.text_fields),
            ),
          ),
          SizedBox(height: 16.h),
          
          // News Date
          Text(
            'News Date',
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
            controller: descriptionController,
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
                  // Save the news data
                  setState(() {
                    showEditView = false;
                  });
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
              SizedBox(width: 16.w),
              ElevatedButton(
                onPressed: () {
                  // Delete the news
                  setState(() {
                    showEditView = false;
                  });
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
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddNewsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add News',
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
          
          // News Title
          Text(
            'News Title',
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
          
          // News Date
          Text(
            'News Date',
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
            controller: descriptionController,
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
          
          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add the news
                setState(() {
                  showAddView = false;
                  
                  // Add the new news to the list
                  if (titleController.text.isNotEmpty) {
                    newsList.insert(0, {
                      'title': titleController.text,
                      'date': dateController.text.isNotEmpty ? dateController.text : 'Monday, 01/01/2024',
                      'description': descriptionController.text.isNotEmpty ? descriptionController.text : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                      'image': 'assets/images/News.png',
                    });
                  }
                });
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
          ),
        ],
      ),
    );
  }
} 