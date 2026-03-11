import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';

class SafetyShieldAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;

  const SafetyShieldAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.onMenuTap,
    this.onSearchTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,

      // ── Leading: hamburger icon + Group.png avatar ──────────
      leadingWidth: 80,
      leading: leading ??
          IconButton(
            padding: EdgeInsets.zero,
            icon: Image.asset(
              'assets/icons/icon-park_hamburger-button.png',
              width: 36,
              height: 36,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.sort,
                color: AppColors.black,
                size: 26,
              ),
            ),
            onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menu',
          ),

      // ── Title ───────────────────────────────────────────────
      title: title != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title!,
            style: AppStyles.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 1),
            Text(
              subtitle!,
              style: AppStyles.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
          ],
        ],
      )
          : Image.asset(
        'assets/icons/safety_appbar_logo.png',
        height: 30,
        fit: BoxFit.contain,
      ),

      centerTitle: title == null,
      titleSpacing: 0,

      // ── Actions ─────────────────────────────────────────────
      actions: actions ??
          (onSearchTap != null
              ? [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.black, size: 26),
              onPressed: onSearchTap,
              tooltip: 'Search',
            ),
          ]
              : [const SizedBox(width: 8)]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helper — returns the correct AppBar for each tab index
// ─────────────────────────────────────────────────────────────

SafetyShieldAppBar appBarForTab(
    int index, {
      VoidCallback? onSearchTap,
      VoidCallback? onMenuTap,
      VoidCallback? onProfileTap,
    }) {
  switch (index) {
    case 0:
      return SafetyShieldAppBar(
        onMenuTap: onMenuTap,
        onSearchTap: onSearchTap,
        onProfileTap: onProfileTap,
      );
    case 1:
      return SafetyShieldAppBar(
        title: 'Alerts',
        subtitle: '14 Today • 5 Active',
        onMenuTap: onMenuTap,
        onProfileTap: onProfileTap,
      );
    case 2:
      return SafetyShieldAppBar(
        title: 'Camera',
        subtitle: 'Live Feed',
        onMenuTap: onMenuTap,
        onProfileTap: onProfileTap,
      );
    case 3:
      return SafetyShieldAppBar(
        title: 'Zone Map',
        subtitle: 'All Zones',
        onMenuTap: onMenuTap,
        onProfileTap: onProfileTap,
      );
    case 4:
      return SafetyShieldAppBar(
        title: 'Profile',
        onMenuTap: onMenuTap,
        onProfileTap: onProfileTap,
      );
    default:
      return SafetyShieldAppBar(onMenuTap: onMenuTap);
  }
}