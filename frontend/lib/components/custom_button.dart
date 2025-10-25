// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final String text;
  final VoidCallback onTap;
  final double? borderRadius;
  final Widget? icon;
  final MainAxisAlignment? alignment;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  
  const CustomButton({
    super.key,
    this.color,
    this.textColor,
    this.width,
    this.height,
    required this.text,
    required this.onTap,
    this.borderRadius,
    this.icon,
    this.alignment,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? size.width,
        height: height ?? 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF134074),
          borderRadius: BorderRadius.circular(borderRadius ?? 30.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 24.h),
          child: Row(
            mainAxisAlignment: alignment ?? MainAxisAlignment.start,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 12.w),
              ],
              Text(
                text, 
                style: textStyle ?? TextStyle(
                  color: textColor ?? const Color(0xFFFFFFFF), 
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp, 
                  fontFamily: "Gothic"
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
