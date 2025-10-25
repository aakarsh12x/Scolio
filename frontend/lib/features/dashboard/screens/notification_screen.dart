import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/utils/navigation_manager.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Sample notification data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Teacher and Parent\'s Meeting Update!',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ex urna, lobortis a nisi a, facilisis tincidunt magna.',
      'avatar': null,
      'type': 'meeting',
      'time': '2 hours ago',
      'isRead': false,
    },
    {
      'title': 'School Trip to the Zoo 🦒🦁🐘',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ex urna, lobortis a nisi a, facilisis tincidunt magna.',
      'avatar': null,
      'type': 'trip',
      'time': '1 day ago',
      'isRead': false,
    },
    {
      'title': 'Canteen Menu Update!🍕🍔🌮🥗🍛🍲',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ex urna, lobortis a nisi a, facilisis tincidunt magna.',
      'avatar': null,
      'type': 'canteen',
      'time': '2 days ago',
      'isRead': true,
    },
    {
      'title': 'Student Fee - Due on 17 Jan 💲',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ex urna, lobortis a nisi a, facilisis tincidunt magna.',
      'avatar': null,
      'type': 'fee',
      'time': '1 week ago',
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Notification',
        showBackButton: true,
        onLeadingPressed: () {
          // Go back to previous screen
          Navigator.pop(context);
        },
      ),
      drawer: const CustomDrawer(),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationsList(),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: NavigationManager.currentBottomNavIndex,
        onTap: (index) {
          NavigationManager.navigateFromBottomBar(index, context);
        },
        isTeacherMode: NavigationManager.isTeacherMode,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Set the current bottom nav index to the Notification tab (index 3)
    NavigationManager.currentBottomNavIndex = 3;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You don\'t have any notifications yet',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: _notifications.length,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification, index);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(notification, index),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  notification['description'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Divider(color: Colors.grey[300]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> notification, int index) {
    Color backgroundColor;
    IconData iconData;
    
    // Set avatar properties based on notification type
    switch (notification['type']) {
      case 'meeting':
        backgroundColor = Colors.blue[100]!;
        iconData = Icons.people;
        break;
      case 'trip':
        backgroundColor = Colors.orange[100]!;
        iconData = Icons.card_travel;
        break;
      case 'canteen':
        backgroundColor = Colors.green[100]!;
        iconData = Icons.restaurant;
        break;
      case 'fee':
        backgroundColor = Colors.purple[100]!;
        iconData = Icons.attach_money;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        iconData = Icons.notifications;
    }
    
    return CircleAvatar(
      radius: 22.r,
      backgroundColor: backgroundColor,
      child: notification['avatar'] != null
          ? Image.asset(
              notification['avatar'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                iconData,
                color: backgroundColor.withBlue(backgroundColor.blue + 100),
                size: 24.sp,
              ),
            )
          : Icon(
              iconData,
              color: backgroundColor.withBlue(backgroundColor.blue + 100),
              size: 24.sp,
            ),
    );
  }
} 