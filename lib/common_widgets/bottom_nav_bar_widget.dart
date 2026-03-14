import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';

enum SafetyShieldTab { home, alerts, camera, zonemap, profile }

class SafetyShieldBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final bool hasAlerts;

  const SafetyShieldBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.hasAlerts = false,
  });

  static const double iconSize = 26;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                iconAsset: 'assets/icons/Frame 2147226088.png',
                isActive: currentIndex == 0,
                onTap: () => onTabChanged(0),
              ),

              _NavItem(
                iconAsset: 'assets/icons/Frame not.png',
                isActive: currentIndex == 1,
                onTap: () => onTabChanged(1),
              ),

              _CameraNavItem(
                isActive: currentIndex == 2,
                hasAlerts: hasAlerts,
                onTap: () => onTabChanged(2),
              ),

              _NavItem(
                iconAsset: 'assets/icons/mynaui_map.png',
                isActive: currentIndex == 3,
                onTap: () => onTabChanged(3),
              ),

              _NavItem(
                iconAsset: 'assets/icons/user_outlined.png',
                isActive: currentIndex == 4,
                onTap: () => onTabChanged(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconAsset;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.iconAsset,
    required this.isActive,
    required this.onTap,
  });

  static const double iconSize = 26;
  static const Color _activeColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: _buildIcon(),
            ),
            const SizedBox(height: 6),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? _activeColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: ColorFiltered(
        key: ValueKey(isActive),
        colorFilter: ColorFilter.matrix(isActive ? _blueMatrix : _greyMatrix),
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: Image.asset(iconAsset, fit: BoxFit.contain),
        ),
      ),
    );
  }

  static const List<double> _blueMatrix = [
    0,
    0,
    0,
    0,
    31,
    0,
    0,
    0,
    0,
    143,
    0,
    0,
    0,
    0,
    181,
    0,
    0,
    0,
    1,
    0,
  ];

  static const List<double> _greyMatrix = [
    0,
    0,
    0,
    0,
    170,
    0,
    0,
    0,
    0,
    170,
    0,
    0,
    0,
    0,
    170,
    0,
    0,
    0,
    1,
    0,
  ];
}

class _CameraNavItem extends StatelessWidget {
  final bool isActive;
  final bool hasAlerts;
  final VoidCallback onTap;

  const _CameraNavItem({
    required this.isActive,
    required this.hasAlerts,
    required this.onTap,
  });

  static const double iconSize = 26;
  static const Color _activeColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: SizedBox(
                width: 32,
                height: 32,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                        isActive ? _NavItem._blueMatrix : _NavItem._greyMatrix,
                      ),
                      child: SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: Image.asset(
                          'assets/icons/tabler_device-cctv.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    if (hasAlerts)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? _activeColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
