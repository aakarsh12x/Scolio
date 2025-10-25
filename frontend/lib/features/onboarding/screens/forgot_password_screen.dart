import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_app_bar.dart';
import 'package:school_management/components/custom_button.dart';
import 'package:school_management/components/custom_headin_text.dart';
import 'package:school_management/components/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Forgot Password",
        leading: IconButton(
          icon: Image.asset(
            "assets/icons/Back Arrow.png",
            width: 24.w,
            height: 24.h,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
            Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Image.asset(
              "assets/images/customer_support.png",
              width: 24.w,
              height: 24.h,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Form(
            key: _formKey,
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                SizedBox(height: 20.h),
                CustomHeadingText(
                  headingText: "Forgot Password?",
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF134074),
                  fontFamily: 'Arial',
                ),
                SizedBox(height: 12.h),
                Text(
                  "Enter your email address and we'll send you a link to reset your password.",
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                  ),
                SizedBox(height: 40.h),
                CustomTextField(
                  hintText: "Email Address",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
            ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: "Reset Password",
                  alignment: MainAxisAlignment.center,
                      onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Show success message
                      Get.snackbar(
                        'Email Sent',
                        'Please check your email for password reset instructions',
                        backgroundColor: const Color(0xFF134074),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(16.sp),
                        borderRadius: 8.r,
                      );
                    }
                      },
                ),
                SizedBox(height: 30.h),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/forgot_password.png",
                    width: 250.w,
                    fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
