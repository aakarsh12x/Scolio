import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_headin_text.dart';
import 'package:school_management/utils/navigation_manager.dart';
import 'package:school_management/utils/app_screen_type.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final Color? titleColor;
  final double? titleSize;
  final Function()? onLeadingPressed;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = true,
    this.titleColor,
    this.titleSize,
    this.onLeadingPressed,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomHeadingText(
        headingText: title,
        fontSize: titleSize ?? 20.sp,
        color: titleColor ?? const Color(0xFF134074),
        fontWeight: FontWeight.w600,
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 0,
      leadingWidth: 56.w,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xFF13315C),
              ),
              onPressed: onLeadingPressed ?? () {
                // When going back, let NavigationManager manage the state
                if (NavigationManager.currentScreenType == AppScreenType.feature) {
                  // Simple back if we're in a feature screen
                  Get.back();
                } else {
                  // Otherwise, use our navigation handler
                  NavigationManager.handleBackNavigation();
                }
              },
            )
          : leading ??
            IconButton(
              icon: Image.asset(
                "assets/icons/Menu.png",
                width: 24.w,
                height: 24.h,
              ),
              onPressed: onLeadingPressed ?? () {},
            ),
      actions: actions ??
          [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Image.asset(
                "assets/icons/Notification.png",
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
} 