import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';

/// Tab items for the SafetyShield bottom navigation bar.
enum SafetyShieldTab { home, alerts, camera, map, profile }

/// A reusable BottomNavigationBar widget matching the SafetyShield dashboard design.
///
/// Features:
/// - 5 tabs: Home, Alerts, Camera, Map, Profile
/// - Custom PNG icons or Material icons
/// - Alerts tab shows an animated blinking red-dot icon when [hasAlerts] is true
/// - Active tab highlighted with the brand blue color and dot indicator
///
/// Usage:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: SafetyShieldBottomNavBar(
///     currentIndex: _currentIndex,
///     onTabChanged: (index) => setState(() => _currentIndex = index),
///     hasAlerts: true, // optional – enables alert blink on the Alerts tab
///   ),
/// )
/// ```
class SafetyShieldBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  /// When true, the Alerts tab shows the animated blinking icon.
  final bool hasAlerts;

  const SafetyShieldBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.hasAlerts = false,
  });

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
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ── Home ────────────────────────────────────────────────────
              _NavItem(
                iconData: Icons.home_outlined,
                activeIconData: Icons.home_outlined,
                isActive: currentIndex == 0,
                onTap: () => onTabChanged(0),
              ),

              // ── Alerts (bell icon) ────────────────────────────────
              _NavItem(
                iconData: Icons.notifications_none,
                activeIconData: Icons.notifications_none,
                isActive: currentIndex == 1,
                onTap: () => onTabChanged(1),
              ),

              // ── Camera (blinking CCTV when hasAlerts) ────────────────────
              _CameraNavItem(
                isActive: currentIndex == 2,
                hasAlerts: hasAlerts,
                onTap: () => onTabChanged(2),
              ),

              // ── Map ────────────────────────────────────────────────
              _NavItem(
                iconData: Icons.map_outlined,
                activeIconData: Icons.map_outlined,
                isActive: currentIndex == 3,
                onTap: () => onTabChanged(3),
              ),

              // ── Profile ─────────────────────────────────────────────────
              _NavItem(
                iconData: Icons.person_outline,
                activeIconData: Icons.person_outline,
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

// ---------------------------------------------------------------------------
// Standard nav item (supports both Material icon and PNG asset)
// ---------------------------------------------------------------------------

class _NavItem extends StatelessWidget {
  final IconData? iconData;
  final IconData? activeIconData;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.isActive,
    required this.onTap,
    this.iconData,
    this.activeIconData,
  });

  static const Color _activeColor = AppColors.primary;
  static const Color _inactiveColor = AppColors.grey;

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
            _buildIcon(),
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
    // Fallback to Material icon
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        isActive ? (activeIconData ?? iconData) : iconData,
        key: ValueKey(isActive),
        color: isActive ? _activeColor : _inactiveColor,
        size: 26,
      ),
    );
  }

  /// ColorMatrix that maps greyscale icon to brand blue (0xFF1F8FB5).
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

  /// ColorMatrix that keeps a greyscale icon grey (0xFF9E9E9E).
  static const List<double> _greyMatrix = [
    0,
    0,
    0,
    0,
    158,
    0,
    0,
    0,
    0,
    158,
    0,
    0,
    0,
    0,
    158,
    0,
    0,
    0,
    1,
    0,
  ];
}

// ---------------------------------------------------------------------------
// Camera nav item with static red dot when hasAlerts is true
// ---------------------------------------------------------------------------

class _CameraNavItem extends StatelessWidget {
  final bool isActive;
  final bool hasAlerts;
  final VoidCallback onTap;

  const _CameraNavItem({
    required this.isActive,
    required this.hasAlerts,
    required this.onTap,
  });

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
            // Use a Stack to position the red dot over the CCTV icon
            SizedBox(
              width: 32,
              height: 32,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.matrix(
                      isActive ? _NavItem._blueMatrix : _NavItem._greyMatrix,
                    ),
                    child: Image.asset(
                      'assets/icons/tabler_device-cctv.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  if (hasAlerts)
                    Positioned(
                      top: 0,
                      right: 0,
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
            const SizedBox(height: 2), // Adjusted spacing slightly
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
