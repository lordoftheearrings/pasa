import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/config/router/app_routes.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.home.name);
        break;
      case 1:
        context.goNamed(AppRoutes.safety.name);
        break;
      case 2:
        context.goNamed(AppRoutes.rides.name);
        break;
      case 3:
        context.goNamed(AppRoutes.maps.name);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.flag_outlined),
          label: 'Rides',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
      ],
    );
  }
}
