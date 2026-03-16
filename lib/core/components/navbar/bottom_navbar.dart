import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';

class AppBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppBottomNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    void onTap(int currentIndex) {
      switch (currentIndex) {
        case 0:
          navigationShell.goBranch(0);
          break;
        case 1:
          navigationShell.goBranch(1);
          break;
        case 2:
          navigationShell.goBranch(2);
          break;
        case 3:
          navigationShell.goBranch(3);
          break;
      }
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => onTap(index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.hint,
      backgroundColor: AppColors.black,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      useLegacyColorScheme: true,
      selectedLabelStyle: AppTextStyles.bodyText16,
      iconSize: 26,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety),
          label: 'Safety',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Status'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
      ],
    );
  }
}
