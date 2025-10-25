import 'package:get/get.dart';
import 'package:school_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:school_management/features/onboarding/screens/start_up_screen.dart';
import 'package:school_management/features/teacher/screens/teacher_dashboard_screen.dart';
import 'package:school_management/utils/navigation_manager.dart';

class OnBoardingController extends GetxController {
  RxString selctedUser = "Select User".obs;
  RxDouble value = 3.0.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Just reset the navigation state completely on startup
    NavigationManager.resetNavigationState();
    
    // Automatically navigate to StartupScreen after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => const StartUpScreen());
    });
  }

  void selectUser(String user) {
    selctedUser.value = user;
  }
}
