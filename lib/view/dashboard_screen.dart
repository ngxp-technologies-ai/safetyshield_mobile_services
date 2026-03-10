import 'package:flutter/material.dart';
import 'package:safety_management/common_widgets/common_widgets.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';

/// Example dashboard screen demonstrating how to use
/// [SafetyShieldAppBar] and [SafetyShieldBottomNavBar] together.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  /// Whether there are unread alerts (drives the blinking icon on the Alerts tab).
  bool _hasAlerts = true;

  /// Pages mapped to each bottom nav tab.
  final List<Widget> _pages = const [
    _HomeTab(),
    _PlaceholderTab(label: 'Alerts'),
    _PlaceholderTab(label: 'Camera'),
    _PlaceholderTab(label: 'Settings'),
    _PlaceholderTab(label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      // ─── AppBar ───────────────────────────────────────────────────────────
      appBar: SafetyShieldAppBar(
        onMenuTap: () => Scaffold.of(context).openDrawer(),
        onSearchTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Search tapped')));
        },
      ),
      // ─── Body ─────────────────────────────────────────────────────────────
      body: IndexedStack(index: _currentIndex, children: _pages),
      // ─── Bottom Nav Bar ───────────────────────────────────────────────────
      bottomNavigationBar: SafetyShieldBottomNavBar(
        currentIndex: _currentIndex,
        hasAlerts: _hasAlerts,
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
            // Clear alert blink when the user opens the Camera tab
            if (index == 2) _hasAlerts = false;
          });
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Placeholder tabs (replace with real page widgets)
// ---------------------------------------------------------------------------

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning ☀️', style: AppStyles.headlinePoppins),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Jacob Santos',
                        style: AppStyles.poppins(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '● On Shift',
                  style: AppStyles.poppins(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Assigned site card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assigned Site',
                  style: AppStyles.poppins(color: AppColors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metro Line 3',
                      style: AppStyles.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'online since  07:00',
                      style: AppStyles.poppins(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StatChip(label: 'Crew', value: '29', icon: Icons.group_outlined),
              _StatChip(
                label: 'Alert',
                value: '5',
                icon: Icons.warning_amber_outlined,
              ),
              _StatChip(
                label: 'Camera',
                value: '4',
                icon: Icons.videocam_outlined,
              ),
              _StatChip(
                label: 'Escalation',
                value: '1',
                icon: Icons.report_outlined,
                valueColor: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppStyles.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppStyles.poppins(fontSize: 11, color: AppColors.grey),
        ),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: AppStyles.poppins(fontSize: 20, color: AppColors.grey),
      ),
    );
  }
}
