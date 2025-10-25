import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.shadowColor,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.border,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.black.withOpacity(0.1),
              blurRadius: elevation ?? 5,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
          border: border,
          gradient: gradient,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.all(16.sp),
          child: child,
        ),
      ),
    );
  }
} 