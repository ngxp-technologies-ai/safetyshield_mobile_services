import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';

class SafetyShieldAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;

  const SafetyShieldAppBar({super.key, this.onMenuTap, this.onSearchTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      // ------- Left: Hamburger menu -------
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.black, size: 26),
        onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
        tooltip: 'Menu',
      ),
      // ------- Center: Logo -------
      // AFTER
      title: Image.asset(
        'assets/images/safety_appbar_logo.png',
        height: 30,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
      // ------- Right: Search icon -------
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.black, size: 26),
          onPressed: onSearchTap,
          tooltip: 'Search',
        ),
      ],
    );
  }
}
