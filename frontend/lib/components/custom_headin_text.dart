import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHeadingText extends StatelessWidget {
  final String headingText;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  
  const CustomHeadingText({
    super.key,
    required this.headingText,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      headingText,
      style: TextStyle(
        fontFamily: fontFamily ?? 'Coolvetica',
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize?.sp ?? 22.sp,
        color: color ?? const Color(0xFF134074),
        letterSpacing: letterSpacing,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      softWrap: true,
    );
  }
}
