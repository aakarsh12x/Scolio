import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int maxLine;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLine = 1,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.fillColor,
    this.hintStyle,
    this.textStyle,
    this.borderRadius,
    this.contentPadding,
    this.focusNode,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: fillColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLine,
        obscureText: obscureText,
        keyboardType: keyboardType,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ?? GoogleFonts.roboto(
            color: const Color(0xFF757575),
            fontSize: 14.sp,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: contentPadding ?? 
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          filled: true,
          fillColor: fillColor ?? Colors.white,
        ),
        style: textStyle ?? GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
