import 'package:flutter/material.dart';

/// Tab items for the SafetyShield bottom navigation bar.
enum SafetyShieldTab { home, alerts, camera, settings, profile }

/// A reusable BottomNavigationBar widget matching the SafetyShield dashboard design.
///
/// Features:
/// - 5 tabs: Home, Alerts, Camera, Settings, Profile
/// - Custom PNG icons for each tab
/// - Alerts tab shows an animated blinking red-dot icon when [hasAlerts] is true
/// - Active tab highlighted with the brand blue color
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
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
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
                iconAsset: null,
                iconData: Icons.home_outlined,
                activeIconData: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTabChanged(0),
              ),

              // ── Alerts (static bell icon) ────────────────────────────────
              _NavItem(
                iconAsset: 'assets/icons/home.png',
                label: 'Alerts',
                isActive: currentIndex == 1,
                onTap: () => onTabChanged(1),
              ),

              // ── Camera (blinking CCTV when hasAlerts) ────────────────────
              _CameraNavItem(
                isActive: currentIndex == 2,
                hasAlerts: hasAlerts,
                onTap: () => onTabChanged(2),
              ),

              // ── Settings ────────────────────────────────────────────────
              _NavItem(
                iconAsset: 'assets/icons/Frame-2.png',
                label: 'Settings',
                isActive: currentIndex == 3,
                onTap: () => onTabChanged(3),
              ),

              // ── Profile ─────────────────────────────────────────────────
              _NavItem(
                iconAsset: 'assets/icons/Frame.png',
                label: 'Profile',
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
  final String? iconAsset;
  final IconData? iconData;
  final IconData? activeIconData;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.iconAsset,
    this.iconData,
    this.activeIconData,
  });

  static const Color _activeColor = Color(0xFF1F8FB5);
  static const Color _inactiveColor = Color(0xFFAAAAAA);

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
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? _activeColor : _inactiveColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (iconAsset != null) {
      // PNG asset icon – tint with ColorFiltered when active
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: ColorFiltered(
          key: ValueKey(isActive),
          colorFilter: ColorFilter.matrix(isActive ? _blueMatrix : _greyMatrix),
          child: Image.asset(iconAsset!, width: 24, height: 24),
        ),
      );
    }

    // Fallback to Material icon
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        isActive ? (activeIconData ?? iconData) : iconData,
        key: ValueKey(isActive),
        color: isActive ? _activeColor : _inactiveColor,
        size: 24,
      ),
    );
  }

  /// ColorMatrix that maps greyscale icon to brand blue (0xFF1F8FB5).
  static const List<double> _blueMatrix = [
    0,
    0,
    0,
    0,
    31 / 255,
    0,
    0,
    0,
    0,
    143 / 255,
    0,
    0,
    0,
    0,
    181 / 255,
    0,
    0,
    0,
    1,
    0,
  ];

  /// ColorMatrix that keeps a greyscale icon grey (0xFFAAAAAA).
  static const List<double> _greyMatrix = [
    0,
    0,
    0,
    0,
    170 / 255,
    0,
    0,
    0,
    0,
    170 / 255,
    0,
    0,
    0,
    0,
    170 / 255,
    0,
    0,
    0,
    1,
    0,
  ];
}

// ---------------------------------------------------------------------------
// Camera nav item with blinking alertblink animation
// ---------------------------------------------------------------------------

class _CameraNavItem extends StatefulWidget {
  final bool isActive;
  final bool hasAlerts;
  final VoidCallback onTap;

  const _CameraNavItem({
    required this.isActive,
    required this.hasAlerts,
    required this.onTap,
  });

  @override
  State<_CameraNavItem> createState() => _CameraNavItemState();
}

class _CameraNavItemState extends State<_CameraNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final Animation<double> _blinkAnim;

  static const Color _activeColor = Color(0xFF1F8FB5);
  static const Color _inactiveColor = Color(0xFFAAAAAA);

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _blinkAnim = Tween<double>(begin: 1.0, end: 0.15).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    _updateBlink();
  }

  @override
  void didUpdateWidget(_CameraNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasAlerts != widget.hasAlerts) {
      _updateBlink();
    }
  }

  void _updateBlink() {
    if (widget.hasAlerts) {
      _blinkController.repeat(reverse: true);
    } else {
      _blinkController.stop();
      _blinkController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Blink the alertblink.png (CCTV + red dot) when hasAlerts is true,
            // otherwise show the regular CCTV icon.
            widget.hasAlerts
                ? FadeTransition(
                    opacity: _blinkAnim,
                    child: Image.asset(
                      'assets/icons/alertblink.png',
                      width: 26,
                      height: 26,
                    ),
                  )
                : ColorFiltered(
                    colorFilter: ColorFilter.matrix(
                      widget.isActive
                          ? _NavItem._blueMatrix
                          : _NavItem._greyMatrix,
                    ),
                    child: Image.asset(
                      'assets/icons/tabler_device-cctv.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                color: widget.isActive ? _activeColor : _inactiveColor,
              ),
              child: const Text('Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
