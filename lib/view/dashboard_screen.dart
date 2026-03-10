import 'package:flutter/material.dart';
import 'package:safety_management/common_widgets/common_widgets.dart';

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
      backgroundColor: const Color(0xFFF5F6FA),
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

class _GoodMorningSection extends StatelessWidget {
  const _GoodMorningSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// GOOD MORNING + SHIFT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    "Good Morning",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Text("☀️", style: TextStyle(fontSize: 18)),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffDFF4E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Color(0xff2DB468)),
                    SizedBox(width: 6),
                    Text(
                      "On Shift",
                      style: TextStyle(
                        color: Color(0xff2DB468),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// USER NAME
          const Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                "Jacob Santos",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Divider(),

          const SizedBox(height: 12),

          /// ASSIGNED SITE
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffE9EAEC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assigned Site",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Metro Line 3",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "online since: 07:00",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _StatCard(
          icon: "assets/images/crew_icon.png",
          title: "Crew",
          value: "29",
        ),

        _StatCard(
          icon: "assets/images/alert_icon.png",
          title: "Alert",
          value: "5",
          iconColor: Colors.red,
        ),

        _StatCard(
          icon: "assets/images/camera_icon.png",
          title: "Camera",
          value: "4",
          showGreenDot: true,
        ),

        _StatCard(
          icon: "assets/images/warning_icon.png",
          title: "Escalation",
          value: "1",
          iconColor: Colors.orange,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color iconColor;
  final bool showGreenDot;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = const Color(0xFF1F8FB5),
    this.showGreenDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// ICON WITH OPTIONAL DOT
          Stack(
            children: [
              Image.asset(icon, height: 22, color: iconColor),

              if (showGreenDot)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2DB468),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),

          /// TITLE
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),

          /// VALUE
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
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
          _GoodMorningSection(),
          const SizedBox(height: 12),
          _StatsSection(),
          const SizedBox(height: 12),

          /// ASSIGNED ZONES HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Text(
                    "Assigned Zones",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "4 zones",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Text(
                "View All",
                style: TextStyle(
                  color: Color(0xFF1F8FB5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ZONES GRID
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: const [
              _ZoneCard(
                title: "Foundation pit",
                zone: "Zone A",
                status: "Safe",
                statusColor: Color(0xFF2DB468),
                crew: 12,
                alerts: 0,
              ),

              _ZoneCard(
                title: "Scaffolding",
                zone: "Zone B",
                status: "Critical",
                statusColor: Color(0xFFE53935),
                crew: 8,
                alerts: 3,
              ),

              _ZoneCard(
                title: "Crane Ops",
                zone: "Zone C",
                status: "Warning",
                statusColor: Color(0xFFFFB300),
                crew: 5,
                alerts: 1,
              ),

              _ZoneCard(
                title: "Material Storage",
                zone: "Zone D",
                status: "Safe",
                statusColor: Color(0xFF2DB468),
                crew: 4,
                alerts: 0,
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final String title;
  final String zone;
  final String status;
  final Color statusColor;
  final int crew;
  final int alerts;

  const _ZoneCard({
    required this.title,
    required this.zone,
    required this.status,
    required this.statusColor,
    required this.crew,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/location_icon.png", height: 22),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TITLE
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

          Text(zone, style: const TextStyle(color: Colors.grey, fontSize: 12)),

          const Spacer(),

          /// CREW + ALERT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset("assets/images/crew_icon.png", height: 14),
                  const SizedBox(width: 4),
                  Text("$crew", style: const TextStyle(fontSize: 12)),
                ],
              ),

              Row(
                children: [
                  Image.asset("assets/images/alert_icon.png", height: 14),
                  const SizedBox(width: 4),
                  Text("$alerts", style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
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
        style: const TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );
  }
}
