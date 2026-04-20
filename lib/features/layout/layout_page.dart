import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/router/app_router.dart';
import 'package:malaz/core/theme/app_colors.dart';

class LayoutPage extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final void Function(int) onTap;
  const LayoutPage({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
  });

  // void _onItemTapped(BuildContext context, int index) {
  //   switch (index) {
  //     case 0:
  //       context.go(AppRouter.rooms);
  //       break;
  //     case 1:
  //       context.go(AppRouter.stats);
  //       break;
  //     case 2:
  //       context.go(AppRouter.profile);
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: onTap,
        indicatorColor: AppColors.primaryColor.withAlpha(255 ~/ 10),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_max),
            selectedIcon: Icon(Icons.home_max, color: AppColors.primaryColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            selectedIcon: Icon(
              Icons.bar_chart_rounded,
              color: AppColors.primaryColor,
            ),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(Icons.person, color: AppColors.primaryColor),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
