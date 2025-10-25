import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF13315C),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
        ),
        displayMedium: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
        ),
        displaySmall: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          overflow: TextOverflow.ellipsis,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          overflow: TextOverflow.ellipsis,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          color: Colors.black87,
          overflow: TextOverflow.ellipsis,
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp, 
          color: Colors.grey,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF13315C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF13315C),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF13315C),
        ),
      ),
    );
  }
} 