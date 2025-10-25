import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

sfproDisplayText(
    FontWeight fontWeight, String text, double fontSize, Color color) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'SFProDisplay',
      fontWeight: fontWeight,
      fontSize: fontSize.sp,
      color: color,
    ),
  );
}
