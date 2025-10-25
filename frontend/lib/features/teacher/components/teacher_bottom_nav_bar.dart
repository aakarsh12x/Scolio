import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TeacherBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate bottom padding to account for safe area
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60.h + bottomPadding,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: onTap,
            elevation: 0,
            selectedItemColor: const Color(0xFF13315C),
            unselectedItemColor: const Color(0xFF13315C),
            selectedFontSize: 11.sp,
            unselectedFontSize: 11.sp,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
            showUnselectedLabels: true,
            items: [
              _buildNavItem('Home', 'home'),
              _buildNavItem('Classes', 'class'),
              _buildNavItem('Calendar', 'calendar'),
              _buildNavItem('Notification', 'notification'),
              _buildNavItem('Profile', 'person'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String label, String iconType) {
    bool isSelected = currentIndex == _getIndexFromLabel(label);
    
    return BottomNavigationBarItem(
      icon: Icon(
        _getIconData(iconType),
        size: 24.sp,
        color: const Color(0xFF13315C),
      ),
      activeIcon: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: const Color(0xFF13315C).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          _getIconData(iconType),
          size: 24.sp,
          color: const Color(0xFF13315C),
        ),
      ),
      label: label,
    );
  }

  int _getIndexFromLabel(String label) {
    switch (label) {
      case 'Home': return 0;
      case 'Classes': return 1;
      case 'Calendar': return 2;
      case 'Notification': return 3;
      case 'Profile': return 4;
      default: return 0;
    }
  }

  IconData _getIconData(String iconType) {
    switch (iconType) {
      case 'home':
        return Icons.home;
      case 'class':
        return Icons.class_;
      case 'calendar':
        return Icons.calendar_today;
      case 'notification':
        return Icons.notifications;
      case 'person':
        return Icons.person;
      default:
        return Icons.error_outline;
    }
  }
}
