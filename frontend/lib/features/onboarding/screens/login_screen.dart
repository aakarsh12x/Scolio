import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_button.dart';
import 'package:school_management/components/custom_headin_text.dart';
import 'package:school_management/components/custom_text_field.dart';
import 'package:school_management/features/onboarding/screens/forgot_password_screen.dart';
import 'package:school_management/features/onboarding/controllers/login_controller.dart';
import 'package:school_management/utils/navigation_manager.dart';

class LoginScreen extends StatefulWidget {
  final String userType;
  const LoginScreen({super.key, required this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  
  // Use the login controller
  final LoginController _loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    // Prevent auto-navigation away from login screen
    NavigationManager.isOnLoginScreen = true;
    
    // Ensure we set the navigation manager mode correctly on initialization
    NavigationManager.isTeacherMode = widget.userType.toLowerCase() == 'teachers' || 
                                     widget.userType.toLowerCase() == 'teacher';
  }

  @override
  void dispose() {
    // Reset login screen flag when leaving
    NavigationManager.isOnLoginScreen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Simple back navigation using standard Navigator
                        Navigator.of(context).pop();
                      },
                      icon: Image.asset(
                        "assets/icons/Back Arrow.png",
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                    Image.asset(
                      "assets/icons/Language.png",
                      width: 24.w,
                      height: 24.h,
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                CustomHeadingText(
                  headingText: 'Scolio',
                  fontSize: 50.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 16.h),
                CustomHeadingText(
                  headingText: widget.userType,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Arial',
                ),
                SizedBox(height: 40.h),
                Text(
                  'Login to your Account',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: const Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hintText: 'Email',
                  controller: _loginController.usernameController,
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
                SizedBox(height: 16.h),
                CustomTextField(
                  hintText: 'Password',
                  controller: _loginController.passwordController,
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF757575),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.to(() => const ForgotPasswordScreen()),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: const Color(0xFF134074),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Obx(() => CustomButton(
                  text: _loginController.isLoading.value ? 'Logging in...' : 'Login',
                  alignment: MainAxisAlignment.center,
                  onTap: _loginController.isLoading.value 
                    ? () {}
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          // Call login controller with the user type and context
                          await _loginController.attemptLogin(widget.userType, context);
                        }
                      },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 