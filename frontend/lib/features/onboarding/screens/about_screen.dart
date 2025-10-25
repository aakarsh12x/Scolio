import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:school_management/features/onboarding/controller/onboarding_controller.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingController());
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          Get.to(()=>const DashboardScreen());
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "assets/images/about_screen.png",
           fit: BoxFit.fill,
            
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
