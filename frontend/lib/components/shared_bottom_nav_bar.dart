import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isTeacherMode;

  const SharedBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.isTeacherMode,
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
          // Consistent fixed height for both navbars, with overflow handling
          height: 65.h + bottomPadding,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: onTap,
            elevation: 0,
            selectedItemColor: const Color(0xFF13315C),
            unselectedItemColor: const Color(0xFF13315C),
            selectedFontSize: 11.sp, // Slightly smaller to prevent overflow
            unselectedFontSize: 11.sp, // Slightly smaller to prevent overflow
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
            showUnselectedLabels: true,
            items: isTeacherMode 
              ? [
                  _buildNavItem('Home', 'home'),
                  _buildNavItem('News', 'newspaper'),
                  _buildNavItem('Calendar', 'calendar'),
                  _buildNavItem('Notification', 'notification'),
                  _buildNavItem('Profile', 'person'),
                ]
              : [
                  _buildNavItem('Home', 'home'),
                  _buildNavItem('News', 'newspaper'),
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
      case 'News': return 1;
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
      case 'newspaper':
        return Icons.article;
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