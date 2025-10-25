import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/features/teacher/utils/teacher_navigation_manager.dart';

class TeacherNotificationsScreen extends StatefulWidget {
  const TeacherNotificationsScreen({super.key});

  @override
  State<TeacherNotificationsScreen> createState() => _TeacherNotificationsScreenState();
}

class _TeacherNotificationsScreenState extends State<TeacherNotificationsScreen> with SingleTickerProviderStateMixin {
  int _currentBottomNavIndex = 3;
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Class Schedule Change',
      'message': 'Your Grade 9A Mathematics class has been moved from Room 105 to Room 202 tomorrow.',
      'time': '10 minutes ago',
      'isRead': false,
      'type': 'schedule',
    },
    {
      'id': '2',
      'title': 'Principal Meeting Update',
      'message': 'The staff meeting with the principal will now be held at 3:30 PM instead of 3:00 PM.',
      'time': '2 hours ago',
      'isRead': false,
      'type': 'meeting',
    },
    {
      'id': '3',
      'title': 'Grade Submission Reminder',
      'message': 'Please submit your final grades for the semester by Friday, November 24.',
      'time': '1 day ago',
      'isRead': true,
      'type': 'academics',
    },
    {
      'id': '4',
      'title': 'Professional Development Workshop',
      'message': 'Don\'t forget to register for the upcoming teaching techniques workshop on December 5.',
      'time': '2 days ago',
      'isRead': true,
      'type': 'event',
    },
    {
      'id': '5',
      'title': 'Parent Meeting Request',
      'message': 'Mrs. Johnson has requested a meeting to discuss John\'s progress in mathematics.',
      'time': '3 days ago',
      'isRead': true,
      'type': 'meeting',
    },
    {
      'id': '6',
      'title': 'School Holiday Announcement',
      'message': 'The school will be closed on November 30 for staff development day.',
      'time': '4 days ago',
      'isRead': true,
      'type': 'announcement',
    },
  ];

  final List<Map<String, dynamic>> _archivedNotifications = [
    {
      'id': '7',
      'title': 'Syllabus Submission Deadline',
      'message': 'Thank you for submitting your course syllabus for the next semester.',
      'time': '2 weeks ago',
      'isRead': true,
      'type': 'academics',
    },
    {
      'id': '8',
      'title': 'Teacher Evaluation Results',
      'message': 'Your student evaluation results for the past semester are now available to view.',
      'time': '3 weeks ago',
      'isRead': true,
      'type': 'academics',
    },
    {
      'id': '9',
      'title': 'School Event Participation',
      'message': 'Thank you for volunteering to supervise the science fair next month.',
      'time': '1 month ago',
      'isRead': true,
      'type': 'event',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentBottomNavIndex = TeacherNavigationManager.currentBottomNavIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((item) => item['id'] == id);
      notification['isRead'] = true;
    });
  }

  void _archiveNotification(String id) {
    setState(() {
      final index = _notifications.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        final notification = _notifications.removeAt(index);
        notification['isRead'] = true;
        _archivedNotifications.insert(0, notification);
      }
    });
  }

  void _deleteNotification(String id, bool isArchived) {
    setState(() {
      if (isArchived) {
        _archivedNotifications.removeWhere((item) => item['id'] == id);
      } else {
        _notifications.removeWhere((item) => item['id'] == id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Notifications',
        showBackButton: false,
      ),
      drawer: const TeacherDrawer(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _notifications.isEmpty
                    ? _buildEmptyState('No notifications')
                    : _buildNotificationsList(_notifications, false),
                _archivedNotifications.isEmpty
                    ? _buildEmptyState('No archived notifications')
                    : _buildNotificationsList(_archivedNotifications, true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          TeacherNavigationManager.navigateFromBottomBar(index, context);
        },
        isTeacherMode: true,
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF13315C),
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        indicatorColor: const Color(0xFF13315C),
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'New'),
          Tab(text: 'Archived'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications, bool isArchived) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification, isArchived);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, bool isArchived) {
    final isRead = notification['isRead'] as bool;
    
    IconData typeIcon;
    Color typeColor;
    
    switch (notification['type']) {
      case 'schedule':
        typeIcon = Icons.schedule;
        typeColor = Colors.orange;
        break;
      case 'meeting':
        typeIcon = Icons.people;
        typeColor = Colors.blue;
        break;
      case 'academics':
        typeIcon = Icons.school;
        typeColor = Colors.purple;
        break;
      case 'event':
        typeIcon = Icons.event;
        typeColor = Colors.green;
        break;
      case 'announcement':
        typeIcon = Icons.campaign;
        typeColor = Colors.red;
        break;
      default:
        typeIcon = Icons.notifications;
        typeColor = const Color(0xFF13315C);
    }
    
    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        color: isArchived ? Colors.red : Colors.blue,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.w),
        child: Icon(
          isArchived ? Icons.delete : Icons.archive,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (isArchived) {
            _deleteNotification(notification['id'], true);
            return true;
          } else {
            _archiveNotification(notification['id']);
            return true;
          }
        } else {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm'),
                content: const Text('Are you sure you want to delete this notification?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('DELETE'),
                  ),
                ],
              );
            },
          );
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _deleteNotification(notification['id'], isArchived);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFF5F9FF),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isRead ? Colors.grey.shade200 : const Color(0xFF13315C).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: CircleAvatar(
            backgroundColor: typeColor.withOpacity(0.2),
            child: Icon(
              typeIcon,
              color: typeColor,
            ),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(
                notification['message'],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                notification['time'],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          trailing: !isRead && !isArchived
              ? Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF13315C),
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            if (!isRead && !isArchived) {
              _markAsRead(notification['id']);
            }
            _showNotificationDetails(notification);
          },
        ),
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notification Details',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF13315C),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              notification['title'],
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              notification['time'],
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              notification['message'],
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      _archiveNotification(notification['id']);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(
                        color: Color(0xFF13315C),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Archive',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF13315C),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _deleteNotification(notification['id'], false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
} 