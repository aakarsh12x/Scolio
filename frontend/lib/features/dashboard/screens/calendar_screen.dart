import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/components/custom_drawer.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:school_management/utils/navigation_manager.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/services/db_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<dynamic>> _events;
  late List<dynamic> _selectedEvents;
  final DBService _dbService = DBService();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _initializeEvents();
    _selectedEvents = _getEventsForDay(_selectedDay);
    NavigationManager.currentBottomNavIndex = 2; // Set Calendar tab as active
  }

  void _initializeEvents() {
    _events = {};
    
    // Sample events - in real app, these would come from the backend
    final List<Map<String, dynamic>> sampleEvents = [
      {
        'title': 'Lorem ipsum dolor sit amet',
        'date': DateTime.now(),
        'time': '9:00 AM',
        'completed': false,
        'type': 'task'
      },
      {
        'title': 'Lorem ipsum dolor sit amet',
        'date': DateTime.now(),
        'time': '2:00 PM',
        'completed': false,
        'type': 'task'
      },
      {
        'title': 'Lorem ipsum dolor sit amet',
        'date': DateTime.now().add(const Duration(days: 1)),
        'time': '10:00 AM',
        'completed': false,
        'type': 'task'
      },
      {
        'title': 'Lorem ipsum dolor sit amet',
        'date': DateTime.now().add(const Duration(days: 1)),
        'time': '3:00 PM',
        'completed': false,
        'type': 'task'
      },
      {
        'title': 'Lorem ipsum dolor sit amet',
        'date': DateTime.now().add(const Duration(days: 5)),
        'time': '11:00 AM',
        'completed': false,
        'type': 'task'
      },
      {
        'title': 'Lorem ipsum dolor sit amet',
        'date': DateTime.now().add(const Duration(days: 5)),
        'time': '4:00 PM',
        'completed': false,
        'type': 'task'
      },
    ];

    // Add events to the map
    for (final event in sampleEvents) {
      final DateTime date = event['date'] as DateTime;
      final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      
      if (_events[normalizedDate] != null) {
        _events[normalizedDate]!.add(event);
      } else {
        _events[normalizedDate] = [event];
      }
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final normalizedDate = DateTime(day.year, day.month, day.day);
    return _events[normalizedDate] ?? [];
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
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: CustomAppBar(
          title: 'Calendar',
          showBackButton: true,
          onLeadingPressed: () {
            Get.offAll(() => const DashboardScreen());
          },
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            _buildCalendar(),
            _buildEventsList(),
          ],
        ),
        bottomNavigationBar: SharedBottomNavBar(
          currentIndex: NavigationManager.currentBottomNavIndex,
          onTap: (index) {
            NavigationManager.navigateFromBottomBar(index, context);
          },
          isTeacherMode: NavigationManager.isTeacherMode,
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with back button, title, and notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                  });
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: const Color(0xFF13315C),
                  size: 20.sp,
                ),
              ),
              Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF13315C),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Notification action
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: const Color(0xFF13315C),
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // Month and Year
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM').format(_focusedDay),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                DateFormat('yyyy').format(_focusedDay),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // Calendar Grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;
    
    // Days of week headers
    final weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    
    return Column(
      children: [
        // Week day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((day) => Container(
            width: 40.w,
            height: 40.h,
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          )).toList(),
        ),
        SizedBox(height: 10.h),
        
        // Calendar days
        ...List.generate(6, (weekIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex + 1 - (firstDayWeekday - 1);
              
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return Container(
                  width: 40.w,
                  height: 40.h,
                );
              }
              
              final currentDate = DateTime(_focusedDay.year, _focusedDay.month, dayNumber);
              final isSelected = _selectedDay.year == currentDate.year &&
                  _selectedDay.month == currentDate.month &&
                  _selectedDay.day == currentDate.day;
              final hasEvents = _getEventsForDay(currentDate).isNotEmpty;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = currentDate;
                    _selectedEvents = _getEventsForDay(currentDate);
                  });
                },
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF13315C) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      if (hasEvents && !isSelected)
                        Container(
                          width: 4.w,
                          height: 4.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF13315C),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          );
        }).where((row) {
          // Only show rows that have valid days
          return true;
        }).take(6),
      ],
    );
  }

  Widget _buildEventsList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, dd MMM').format(_selectedDay),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: _selectedEvents.isEmpty
                  ? Center(
                      child: Text(
                        'No events for this date',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _selectedEvents.length,
                      itemBuilder: (context, index) {
                        final event = _selectedEvents[index];
                        return _buildEventItem(event, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(Map<String, dynamic> event, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                event['completed'] = !event['completed'];
              });
            },
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 2,
                ),
                color: event['completed'] ? const Color(0xFF13315C) : Colors.transparent,
              ),
              child: event['completed']
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16.sp,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              event['title'],
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                decoration: event['completed'] ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 