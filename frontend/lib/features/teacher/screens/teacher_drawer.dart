import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/utils/constants.dart';
import 'package:school_management/utils/navigation_manager.dart';
import 'package:school_management/widgets/custom_drawer_item.dart';

class TeacherDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor,
      child: ListView(
        children: [
          CustomDrawerItem(
            title: "Events",
            icon: Icons.event,
            onTap: () {
              NavigationManager.navigateToFeatureScreen('event', context);
              Navigator.pop(context);
            },
          ),
          
          CustomDrawerItem(
            title: "Tests",
            icon: Icons.quiz,
            onTap: () {
              NavigationManager.navigateToFeatureScreen('test', context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
} 