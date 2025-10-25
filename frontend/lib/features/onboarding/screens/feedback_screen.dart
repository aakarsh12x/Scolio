import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_button.dart';
import 'package:school_management/components/custom_headin_text.dart';
import 'package:school_management/components/custom_text_field.dart';
import 'package:school_management/core/util/text_style.dart';
import 'package:school_management/features/onboarding/controller/onboarding_controller.dart';
import 'package:school_management/features/onboarding/screens/about_screen.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OnBoardingController onBoardingController = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                  const CustomHeadingText(heaqdinText: "Feedback"),
                  const SizedBox()
                ],
              ),
            ),
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sfproDisplayText(FontWeight.w700, "Help Us Improve Péče!",
                          20, const Color(0xFF134074)),
                      // Text(
                      //   "Help Us Improve Péče!",
                      //   style: GoogleFonts.inter(
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 20.sp,
                      //       color: const Color(0xFF134074)),
                      // ),
                      SizedBox(height: 10.h),
                      sfproDisplayText(
                        FontWeight.w400,
                        "Your feedback matters. Share your thoughts, suggestions, or any issues you’ve encountered to help us enhance your experience. Together, we can make Péče better for you!",
                        15,
                        const Color(0xFF000000),
                      ),

                      // Text(
                      //     "Your feedback matters. Share your thoughts, suggestions, or any issues you’ve encountered to help us enhance your experience. Together, we can make Péče better for you!",
                      //     style: GoogleFonts.inter(
                      //         fontWeight: FontWeight.w400,
                      //         fontSize: 15.sp,
                      //         color: const Color(0xFF000000)))
                    ],
                  ),
                  SizedBox(height: 30.h),
                  const CustomTextField(hintText: "Name"),

                  SizedBox(height: 10.h),
                  const CustomTextField(hintText: "Subject"),
                  SizedBox(height: 10.h),
                  const CustomTextField(hintText: "Description", maxLine: 6),
                  // SizedBox(height: 0.h),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            CustomButton(
              text: "Submit",
              onTap: () {
                Get.to(() => const AboutScreen());
              },
              width: size.width * 0.35,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: size.width,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.h),
                    child: Image.asset(
                      "assets/images/feedbacki.png",
                      height: 200.h,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Positioned(
                    top: 70.h,
                    left: 170.w,
                    child: Obx(
                      () => RatingStars(
                        valueLabelVisibility: false,
                        value: onBoardingController.value.value,
                        onValueChanged: (v) {
                          onBoardingController.value.value = v;
                        },
                        starBuilder: (index, color) => Icon(
                          Icons.star,
                          color: color,
                          size: 27.sp,
                        ),
                        starCount: 5,
                        starSize: 22,
                        maxValue: 5,
                        starSpacing: 0,
                        maxValueVisibility: true,
                        animationDuration: const Duration(milliseconds: 1000),
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: const Color(0xFF134074),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
