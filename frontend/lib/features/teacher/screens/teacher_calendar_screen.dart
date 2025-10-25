import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/shared_bottom_nav_bar.dart';
import 'package:school_management/features/teacher/components/teacher_drawer.dart';
import 'package:school_management/features/teacher/utils/teacher_navigation_manager.dart';
import 'package:table_calendar/table_calendar.dart';

class TeacherCalendarScreen extends StatefulWidget {
  const TeacherCalendarScreen({super.key});

  @override
  State<TeacherCalendarScreen> createState() => _TeacherCalendarScreenState();
}

class _TeacherCalendarScreenState extends State<TeacherCalendarScreen> {
  int _currentBottomNavIndex = 2;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedEventType = 'All';

  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime.utc(2023, 11, 15): [
      {
        'title': 'Parent-Teacher Meeting',
        'time': '09:00 - 11:30',
        'location': 'School Auditorium',
        'type': 'Meeting',
      },
    ],
    DateTime.utc(2023, 11, 18): [
      {
        'title': 'Mathematics Quiz',
        'time': '10:00 - 11:30',
        'location': 'Room 105',
        'type': 'Exam',
      },
    ],
    DateTime.utc(2023, 11, 20): [
      {
        'title': 'Science Project Submission',
        'time': '14:00 - 15:00',
        'location': 'Science Lab',
        'type': 'Assignment',
      },
    ],
    DateTime.utc(2023, 11, 25): [
      {
        'title': 'Annual Sports Day',
        'time': 'All Day',
        'location': 'School Grounds',
        'type': 'Event',
      },
    ],
    DateTime.utc(2023, 11, 28): [
      {
        'title': 'History Field Trip',
        'time': '09:00 - 15:00',
        'location': 'City Museum',
        'type': 'Field Trip',
      },
    ],
  };

  final List<String> _eventTypes = [
    'All',
    'Meeting',
    'Exam',
    'Assignment',
    'Event',
    'Field Trip',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _currentBottomNavIndex = TeacherNavigationManager.currentBottomNavIndex;
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    final events = _events[normalizedDay] ?? [];

    if (_selectedEventType == 'All') {
      return events;
    } else {
      return events.where((event) => event['type'] == _selectedEventType).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Calendar',
        showBackButton: false,
      ),
      drawer: const TeacherDrawer(),
      body: Column(
        children: [
          _buildCalendar(),
          _buildEventTypeSelector(),
          Expanded(
            child: _getEventsForDay(_selectedDay!).isEmpty
                ? _buildEmptyState()
                : _buildEventsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventBottomSheet(),
        backgroundColor: const Color(0xFF13315C),
        child: const Icon(Icons.add, color: Colors.white),
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

  Widget _buildCalendar() {
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
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF13315C),
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF13315C),
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Color(0xFF13315C),
          ),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: const BoxDecoration(
            color: Color(0xFF13315C),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: const Color(0xFF13315C).withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
          markersAnchor: 1.5,
          markerDecoration: const BoxDecoration(
            color: Color(0xFF13315C),
            shape: BoxShape.circle,
          ),
        ),
        eventLoader: _getEventsForDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildEventTypeSelector() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _eventTypes.length,
        itemBuilder: (context, index) {
          final eventType = _eventTypes[index];
          final isSelected = _selectedEventType == eventType;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedEventType = eventType;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF13315C) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
              ),
              alignment: Alignment.center,
              child: Text(
                eventType,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No events for this day',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap + to add a new event',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    final events = _getEventsForDay(_selectedDay!);
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    Color eventColor;
    IconData eventIcon;

    switch (event['type']) {
      case 'Meeting':
        eventColor = Colors.blue;
        eventIcon = Icons.people;
        break;
      case 'Exam':
        eventColor = Colors.red;
        eventIcon = Icons.assignment;
        break;
      case 'Assignment':
        eventColor = Colors.amber;
        eventIcon = Icons.book;
        break;
      case 'Event':
        eventColor = Colors.green;
        eventIcon = Icons.event;
        break;
      case 'Field Trip':
        eventColor = Colors.purple;
        eventIcon = Icons.explore;
        break;
      default:
        eventColor = const Color(0xFF13315C);
        eventIcon = Icons.event_note;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: CircleAvatar(
          backgroundColor: eventColor.withOpacity(0.2),
          child: Icon(
            eventIcon,
            color: eventColor,
          ),
        ),
        title: Text(
          event['title'],
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 4.w),
                Text(
                  event['time'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 4.w),
                Text(
                  event['location'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: eventColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            event['type'],
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: eventColor,
            ),
          ),
        ),
        onTap: () => _showEventDetails(event),
      ),
    );
  }

  void _showEventDetails(Map<String, dynamic> event) {
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
                  'Event Details',
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
              event['title'],
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow(Icons.calendar_today, 'Date', '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}'),
            SizedBox(height: 8.h),
            _buildDetailRow(Icons.access_time, 'Time', event['time']),
            SizedBox(height: 8.h),
            _buildDetailRow(Icons.location_on, 'Location', event['location']),
            SizedBox(height: 8.h),
            _buildDetailRow(Icons.category, 'Type', event['type']),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Edit Event',
                        'Edit functionality to be implemented',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF134074),
                        colorText: Colors.white,
                      );
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
                      'Edit',
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
                      Get.snackbar(
                        'Delete Event',
                        'Delete functionality to be implemented',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: const Color(0xFF13315C),
        ),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showAddEventBottomSheet() {
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
                  'Add New Event',
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
              'Date: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                hintText: 'e.g. 09:00 - 10:30',
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _eventTypes[1], // Default to first type after 'All'
                  isExpanded: true,
                  hint: const Text('Select Event Type'),
                  items: _eventTypes
                      .where((type) => type != 'All') // Exclude 'All' from options
                      .map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle event type selection
                  },
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Event Added',
                    'Event has been added to your calendar',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF134074),
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13315C),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Add Event',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
} 