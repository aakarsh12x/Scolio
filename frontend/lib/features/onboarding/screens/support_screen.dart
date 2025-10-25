import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_management/components/custom_button.dart';
import 'package:school_management/components/custom_headin_text.dart';
import 'package:school_management/components/custom_text_field.dart';
import 'package:school_management/core/util/text_style.dart';
import 'package:school_management/features/onboarding/screens/forgot_password_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset("assets/icons/Back Arrow.png")),
                  const CustomHeadingText(heaqdinText: "Support"),
                  const SizedBox(),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sfproDisplayText(
                          FontWeight.w700,
                          "Need help? We're here for you!",
                          20,
                          const Color(0xFF134074)),
                      SizedBox(height: 10.h),
                      sfproDisplayText(
                          FontWeight.w400,
                          "If you have any questions, encounter issues, or need assistance with the Péče app, please reach out to us.",
                          15,
                          const Color(0xFF000000)),
                    ],
                  ),
                  SizedBox(height: 45.h),
                  const CustomTextField(hintText: "Name"),
                  SizedBox(height: 10.h),
                  const CustomTextField(hintText: "Email Address"),
                  SizedBox(height: 10.h),
                  const CustomTextField(hintText: "Subject"),
                  SizedBox(height: 10.h),
                  const CustomTextField(hintText: "Description", maxLine: 6),
                  // SizedBox(height: 0.h),
                ],
              ),
            ),
            Stack(
              children: [
                Image.asset("assets/images/support.png"),
                Positioned(
                  top: 50.h,
                  right: 10.w,
                  child: CustomButton(
                    text: "Submit",
                    onTap: () {
                      Get.to(() => const ForgotPasswordScreen());
                    },
                    width: size.width * 0.7,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
