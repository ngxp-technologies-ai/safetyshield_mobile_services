import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';

class SafetyShieldAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;

  const SafetyShieldAppBar({
    super.key,
    this.onMenuTap,
    this.onSearchTap,
    this.title,
    this.subtitle,
    this.actions,
    this.leading,
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
      // ------- Left: Hamburger menu or Custom Leading -------
      leading:
          leading ??
          IconButton(
            icon: const Icon(Icons.sort, color: AppColors.black, size: 26),
            onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menu',
          ),
      // ------- Center: Dynamic Title or Logo -------
      title: title != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title!,
                  style: AppStyles.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppStyles.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors
                          .grey, // Assuming grey matches the subtitle color
                    ),
                  ),
                ],
              ],
            )
          : Image.asset(
              'assets/images/safety_appbar_logo.png',
              height: 30,
              fit: BoxFit.contain,
            ),
      centerTitle: title == null,
      titleSpacing: 0, // Align closer to the menu icon
      // ------- Right: Search icon / Actions -------
      actions:
          actions ??
          (onSearchTap != null
              ? [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.black,
                      size: 26,
                    ),
                    onPressed: onSearchTap,
                    tooltip: 'Search',
                  ),
                ]
              : []),
    );
  }
}
