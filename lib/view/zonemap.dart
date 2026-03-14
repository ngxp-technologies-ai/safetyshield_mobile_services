import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';
import '../utils/app_size.dart';

//  Data models
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

//  Zone Map Screen
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
      workerDots: [Offset(0.25, 0.3), Offset(0.6, 0.25), Offset(0.3, 0.65)],
    ),
    ZoneData(
      name: 'Material Storage',
      zoneId: 'Zone D',
      status: 'Safe',
      workers: 29,
      alerts: 0,
      workerDots: [Offset(0.35, 0.25), Offset(0.65, 0.35), Offset(0.5, 0.65)],
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
        //  Zone Filter Tabs
        Container(
          height: AppSizes.h(44),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.greyLight, width: 1),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w(12)),
            itemCount: _tabs.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: Container(
                  margin: EdgeInsets.only(right: AppSizes.w(4)),
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.w(14)),
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
                      fontSize: AppSizes.fs13,
                      fontWeight: isSelected
                          ? FontWeight.w400
                          : FontWeight.w400,
                      color: isSelected ? AppColors.black : AppColors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        //  Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.space14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Map Section Container
                Container(
                  padding: EdgeInsets.all(AppSizes.space16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      //  2x2 Zone Map Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSizes.space10,
                        mainAxisSpacing: AppSizes.space10,
                        childAspectRatio: 1.75, // REDUCED SIZE
                        children: _zones
                            .map(
                              (zone) => _ZoneMapBox(
                                zone: zone,
                                bgColor: _zoneBgColor(zone.status),
                                borderColor: _zoneBorderColor(zone.status),
                              ),
                            )
                            .toList(),
                      ),

                      SizedBox(height: AppSizes.space16),

                      //  Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LegendDot(
                            color: const Color(0xFF2DB468),
                            label: 'Safe',
                          ),
                          SizedBox(width: AppSizes.space16),
                          _LegendDot(
                            color: const Color(0xFFFFB300),
                            label: 'Warning',
                          ),
                          SizedBox(width: AppSizes.space16),
                          _LegendDot(color: AppColors.error, label: 'Critical'),
                          SizedBox(width: AppSizes.w(16)),
                          _LegendDot(color: AppColors.primary, label: 'Worker'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //  Zone List header
                Row(
                  children: [
                    Text(
                      _selectedTab == 0 ? 'All Zones' : _tabs[_selectedTab],
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${filtered.length} zones',
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs13,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                //  Zone List
                ...filtered.map(
                  (zone) => _ZoneListItem(
                    zone: zone,
                    statusColor: _statusColor(zone.status),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//  Zone box in the map grid
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
          ...zone.workerDots.map(
            (pos) => FractionallySizedBox(
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Zone label center
          Center(
            child: Text(
              zone.zoneId,
              style: AppStyles.poppins(
                fontSize: AppSizes.fs15,
                fontWeight: FontWeight.w600,
                color: AppColors.black.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  Legend dot
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSizes.onlineDot,
          height: AppSizes.onlineDot,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppSizes.space4),
        Text(
          label,
          style: AppStyles.poppins(
            fontSize: AppSizes.fs12,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}

//  Zone list item
class _ZoneListItem extends StatelessWidget {
  final ZoneData zone;
  final Color statusColor;

  const _ZoneListItem({required this.zone, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.space10),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.space14,
        vertical: AppSizes.space12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
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
          Image.asset(
            'assets/images/location_icon.png',
            width: 30,
            height: 20,
            color: AppColors.grey900,
          ),
          const SizedBox(width: 10),

          // Name + Zone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.name,
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppSizes.h(2)),
                Text(
                  zone.zoneId,
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs12,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: AppSizes.h(6)),

                // Workers + Alerts
                Row(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: AppSizes.space14,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: AppSizes.space4),
                    Text(
                      '${zone.workers}',
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: AppSizes.space14),
                    Icon(
                      Icons.notifications_active_outlined,
                      size: AppSizes.space14,
                      color: AppColors.error,
                    ),
                    SizedBox(width: AppSizes.space4),
                    Text(
                      '${zone.alerts}',
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs12,
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
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.cardPadding,
              vertical: AppSizes.h(5),
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
              border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
            ),
            child: Text(
              zone.status,
              style: AppStyles.poppins(
                fontSize: AppSizes.fs12,
                fontWeight: FontWeight.w400,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
