import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management/components/custom_button.dart';
import 'package:school_management/components/custom_headin_text.dart';
import 'package:school_management/features/onboarding/controller/onboarding_controller.dart';
import 'package:school_management/features/onboarding/screens/login_screen.dart';
import 'package:school_management/features/onboarding/screens/teacher_login_screen_new.dart';
import 'package:school_management/utils/navigation_manager.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  String selectedUser = "Select User";
  bool isNavigating = false;
  
  @override
  void initState() {
    super.initState();
    // Just reset all navigation flags
    NavigationManager.resetNavigationState();
  }
  
  // Handle user selection
  void _selectUser(String user) {
    setState(() {
      selectedUser = user;
    });
  }
  
  // Exit app confirmation dialog
  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Exit',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }
  
  // Handle navigation to login screens
  void _navigateToLogin(String userType) {
    // Simple guard against double navigation
    if (isNavigating) return;
    
    setState(() {
      isNavigating = true;
    });
    
    // Navigation without GetX to avoid any potential issues
    Future.microtask(() {
      if (userType == "Parents") {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              LoginScreen(userType: userType),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ).then((_) {
          // Reset navigation flag when returning
          if (mounted) {
            setState(() {
              isNavigating = false;
            });
          }
        });
      } else if (userType == "Teachers") {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              const TeacherLoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ).then((_) {
          // Reset navigation flag when returning
          if (mounted) {
            setState(() {
              isNavigating = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return WillPopScope(
      onWillPop: _showExitDialog,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  SizedBox(height: 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      CustomHeadingText(
                        headingText: "Scolio",
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w700,
                    ),
                      Image.asset(
                        "assets/icons/Language.png",
                        width: 24.w,
                        height: 24.h,
                      )
                  ],
                ),
                  SizedBox(height: size.height * 0.25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: CustomHeadingText(
                        headingText: selectedUser,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Arial',
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                        width: double.infinity,
                        height: 1,
                        color: const Color(0xFF000000),
                    ),
                  ],
                ),
                  SizedBox(height: 32.h),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      _buildUserTypeCard(
                        context,
                        "Parents",
                        "assets/images/Parents.png",
                      ),
                      _buildUserTypeCard(
                        context,
                        "Teachers",
                        "assets/images/Teachers.png",
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  selectedUser != "Select User"
                    ? CustomButton(
                        text: "Continue",
                        alignment: MainAxisAlignment.center,
                        onTap: () => _navigateToLogin(selectedUser),
                      )
                    : const SizedBox(),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      "assets/icons/Help.png",
                      width: 24.w,
                      height: 24.h,
                    ),
                    ),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(
    BuildContext context,
    String userType,
    String imagePath,
  ) {
    bool isSelected = selectedUser == userType;
    
    return GestureDetector(
      onTap: () {
        _selectUser(userType);
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 60.w) / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected 
              ? Border.all(color: const Color(0xFF13315C), width: 2) 
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
