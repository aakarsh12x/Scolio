import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/features/onboarding/controller/onboarding_controller.dart';

class LogoScreen extends StatelessWidget {
  const LogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller for automatic navigation after 3 seconds
    Get.put(OnBoardingController());
    
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text(
            'Scolio',
            style: TextStyle(
              fontSize: 72.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D47A1), // Darker blue color
              letterSpacing: 2.0,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}