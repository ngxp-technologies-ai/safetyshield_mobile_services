import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';

// ── Data models ──────────────────────────────────────────────
class ZoneData {
  final String name;
  final String zoneId;
  final String status; // Safe, Warning, Critical
  final int workers;
  final int alerts;
  final List<Offset> workerDots; // positions inside zone box

  const ZoneData({
    required this.name,
    required this.zoneId,
    required this.status,
    required this.workers,
    required this.alerts,
    required this.workerDots,
  });
}

// ── Zone Map Screen ──────────────────────────────────────────
class ZoneMapScreen extends StatefulWidget {
  const ZoneMapScreen({super.key});

  @override
  State<ZoneMapScreen> createState() => _ZoneMapScreenState();
}

class _ZoneMapScreenState extends State<ZoneMapScreen> {
  int _selectedTab = 0; // 0=All, 1=ZoneA, 2=ZoneB, 3=ZoneC, 4=ZoneD

  final List<String> _tabs = ['All', 'Zone A', 'Zone B', 'Zone C', 'Zone D'];

  final List<ZoneData> _zones = const [
    ZoneData(
      name: 'Foundation pit',
      zoneId: 'Zone A',
      status: 'Safe',
      workers: 29,
      alerts: 3,
      workerDots: [
        Offset(0.25, 0.3),
        Offset(0.55, 0.2),
        Offset(0.75, 0.35),
        Offset(0.2, 0.65),
        Offset(0.7, 0.7),
      ],
    ),
    ZoneData(
      name: 'Scaffolding',
      zoneId: 'Zone B',
      status: 'Critical',
      workers: 29,
      alerts: 1,
      workerDots: [
        Offset(0.3, 0.25),
        Offset(0.65, 0.2),
        Offset(0.8, 0.45),
        Offset(0.45, 0.65),
      ],
    ),
    ZoneData(
      name: 'Crane Ops',
      zoneId: 'Zone C',
      status: 'Warning',
      workers: 29,
      alerts: 0,
      workerDots: [
        Offset(0.25, 0.3),
        Offset(0.6, 0.25),
        Offset(0.3, 0.65),
      ],
    ),
    ZoneData(
      name: 'Material Storage',
      zoneId: 'Zone D',
      status: 'Safe',
      workers: 29,
      alerts: 0,
      workerDots: [
        Offset(0.35, 0.25),
        Offset(0.65, 0.35),
        Offset(0.5, 0.65),
      ],
    ),
  ];

  List<ZoneData> get _filteredZones {
    if (_selectedTab == 0) return _zones;
    return _zones.where((z) => z.zoneId == _tabs[_selectedTab]).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Critical':
        return AppColors.error;
      case 'Warning':
        return const Color(0xFFFFB300);
      default:
        return const Color(0xFF2DB468);
    }
  }

  Color _zoneBgColor(String status) {
    switch (status) {
      case 'Critical':
        return const Color(0xFFFFE5E5);
      case 'Warning':
        return const Color(0xFFFFF3E0);
      default:
        return const Color(0xFFE5F9EE);
    }
  }

  Color _zoneBorderColor(String status) {
    switch (status) {
      case 'Critical':
        return const Color(0xFFFFB3B3);
      case 'Warning':
        return const Color(0xFFFFCC80);
      default:
        return const Color(0xFFB3EDCD);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredZones;

    return Column(
      children: [
        // ── Zone Filter Tabs ─────────────────────────────────
        Container(
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.greyLight, width: 1),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _tabs.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: isSelected
                        ? const Border(
                      bottom: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    )
                        : null,
                  ),
                  child: Text(
                    _tabs[index],
                    style: AppStyles.poppins(
                      fontSize: 13,
                      fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w400,
                      color:
                      isSelected ? AppColors.black : AppColors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Scrollable content ───────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 2x2 Zone Map Grid ────────────────────────
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                  children: _zones.map((zone) => _ZoneMapBox(
                    zone: zone,
                    bgColor: _zoneBgColor(zone.status),
                    borderColor: _zoneBorderColor(zone.status),
                  )).toList(),
                ),

                const SizedBox(height: 14),

                // ── Legend ───────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendDot(color: const Color(0xFF2DB468), label: 'Safe'),
                    const SizedBox(width: 16),
                    _LegendDot(color: const Color(0xFFFFB300), label: 'Warning'),
                    const SizedBox(width: 16),
                    _LegendDot(color: AppColors.error, label: 'Critical'),
                    const SizedBox(width: 16),
                    _LegendDot(color: AppColors.primary, label: 'Worker'),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Zone List header ─────────────────────────
                Row(
                  children: [
                    Text(
                      _selectedTab == 0
                          ? 'All Zones'
                          : _tabs[_selectedTab],
                      style: AppStyles.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${filtered.length} zones',
                      style: AppStyles.poppins(
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Zone List ────────────────────────────────
                ...filtered.map((zone) => _ZoneListItem(
                  zone: zone,
                  statusColor: _statusColor(zone.status),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Zone box in the map grid ─────────────────────────────────
class _ZoneMapBox extends StatelessWidget {
  final ZoneData zone;
  final Color bgColor;
  final Color borderColor;

  const _ZoneMapBox({
    required this.zone,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Stack(
        children: [
          // Worker dots
          ...zone.workerDots.map((pos) => FractionallySizedBox(
            widthFactor: pos.dx,
            heightFactor: pos.dy,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          )),

          // Zone label center
          Center(
            child: Text(
              zone.zoneId,
              style: AppStyles.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Legend dot ───────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppStyles.poppins(fontSize: 12, color: AppColors.grey),
        ),
      ],
    );
  }
}

// ── Zone list item ───────────────────────────────────────────
class _ZoneListItem extends StatelessWidget {
  final ZoneData zone;
  final Color statusColor;

  const _ZoneListItem({
    required this.zone,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Location icon
          const Icon(Icons.location_on_outlined,
              size: 20, color: AppColors.grey),
          const SizedBox(width: 10),

          // Name + Zone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.name,
                  style: AppStyles.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  zone.zoneId,
                  style: AppStyles.poppins(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 6),

                // Workers + Alerts
                Row(
                  children: [
                    const Icon(Icons.group_outlined,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${zone.workers}',
                      style: AppStyles.poppins(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Icon(Icons.notifications_active_outlined,
                        size: 14, color: AppColors.error),
                    const SizedBox(width: 4),
                    Text(
                      '${zone.alerts}',
                      style: AppStyles.poppins(
                        fontSize: 12,
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: statusColor.withOpacity(0.3), width: 1),
            ),
            child: Text(
              zone.status,
              style: AppStyles.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}