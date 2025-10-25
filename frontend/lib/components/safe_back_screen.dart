import 'package:flutter/material.dart';
import 'package:school_management/utils/navigation_manager.dart';

/// A wrapper widget that handles back navigation safely
/// This prevents the app from accidentally logging out when users navigate back
class SafeBackScreen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final bool isFeatureScreen;

  const SafeBackScreen({
    Key? key,
    required this.child,
    required this.title,
    this.showBackButton = true,
    this.isFeatureScreen = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Let the NavigationManager handle back navigation
        if (isFeatureScreen) {
          // For feature screens, just let the system handle back navigation
          return true;
        } else {
          // For main screens, use our custom back navigation logic
          return await NavigationManager.handleBackNavigation();
        }
      },
      child: child,
    );
  }
} 