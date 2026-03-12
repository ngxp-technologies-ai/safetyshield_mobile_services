import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';
import '../utils/app_size.dart';

class AlertItem {
  final String title;
  final String zone;
  final String camera;
  final String status;
  String state;
  final String escalationTime;
  final String timeAgo;
  final double progress;

  AlertItem({
    required this.title,
    required this.zone,
    required this.camera,
    required this.status,
    required this.state,
    required this.escalationTime,
    required this.timeAgo,
    required this.progress,
  });
}

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _selectedTabIndex = 0;

  final List<AlertItem> _allAlerts = [
    AlertItem(
      title: 'No Helmet Detected',
      zone: 'Zone B — Scaffolding',
      camera: 'CAM-B2',
      status: 'Critical',
      state: 'Active',
      escalationTime: '48s',
      timeAgo: '2m ago',
      progress: 0.3,
    ),
    AlertItem(
      title: 'Unauthorized Entry',
      zone: 'Zone C — Crane Ops',
      camera: 'CAM-C1',
      status: 'Critical',
      state: 'Active',
      escalationTime: '2m 12s',
      timeAgo: '6m ago',
      progress: 0.6,
    ),
    AlertItem(
      title: 'Missing Safety Harness',
      zone: 'Zone C — Crane Ops',
      camera: 'CAM-C1',
      status: 'Warning',
      state: 'Active',
      escalationTime: '4m 12s',
      timeAgo: '6m ago',
      progress: 0.8,
    ),
    AlertItem(
      title: 'Fire Smoke Detected',
      zone: 'Zone A — Storage',
      camera: 'CAM-A1',
      status: 'Critical',
      state: 'Active',
      escalationTime: '0s',
      timeAgo: '1m ago',
      progress: 1.0,
    ),
    AlertItem(
      title: 'Restricted Area Access',
      zone: 'Zone D — Electrical',
      camera: 'CAM-D4',
      status: 'Critical',
      state: 'Active',
      escalationTime: '10s',
      timeAgo: '30s ago',
      progress: 0.9,
    ),
  ];

  List<AlertItem> get _filteredAlerts {
    final stateFilter = _tabs[_selectedTabIndex].split('(')[0];
    return _allAlerts.where((a) => a.state == stateFilter).toList();
  }

  List<String> get _tabs {
    int activeCount = _allAlerts.where((a) => a.state == 'Active').length;
    int ackCount = _allAlerts.where((a) => a.state == 'Acknowledged').length;
    return [
      'Active($activeCount)',
      'Acknowledged($ackCount)',
      'Escalated',
      'Resolved',
    ];
  }

  void _acknowledgeAlert(AlertItem item) {
    setState(() {
      item.state = 'Acknowledged';
      _selectedTabIndex = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} acknowledged'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerts = _filteredAlerts;

    return Column(
      children: [
        // ── Tab Bar ──────────────────────────────────────────
        Container(
          height: AppSizes.h(48),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.greyLight, width: 1),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
            itemBuilder: (context, index) {
              final isSelected = _selectedTabIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = index),
                child: Container(
                  margin: EdgeInsets.only(right: AppSizes.space24),
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
                      fontSize: AppSizes.fs14,
                      fontWeight:
                      isSelected ? FontWeight.w400 : FontWeight.w400,
                      color: isSelected ? AppColors.black : AppColors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Alert List ───────────────────────────────────────
        Expanded(
          child: alerts.isEmpty
              ? Center(
            child: Text(
              'No alerts in this category',
              style: AppStyles.poppins(color: AppColors.grey),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.all(AppSizes.pagePadding),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final item = alerts[index];
              return Padding(
                padding: EdgeInsets.only(bottom: AppSizes.space16),
                child: AlertCard(
                  item: item,
                  onAcknowledge: () => _acknowledgeAlert(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AlertCard extends StatelessWidget {
  final AlertItem item;
  final VoidCallback onAcknowledge;

  const AlertCard({
    super.key,
    required this.item,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = item.status.toLowerCase() == 'critical';
    final isAcknowledged = item.state == 'Acknowledged';

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.w(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header row ──────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSizes.w(16), AppSizes.h(16), AppSizes.w(76), AppSizes.h(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Icon box ─────────────────────────────
                    Container(
                      width: AppSizes.w(46),
                      height: AppSizes.w(46),
                      decoration: BoxDecoration(
                        color: (isCritical ? AppColors.error : AppColors.activeOrange)
                            .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppSizes.w(10)),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/Frame not.png',
                          width: AppSizes.w(22),
                          height: AppSizes.w(22),
                          color: isCritical
                              ? AppColors.error
                              : AppColors.activeOrange,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.notifications_none,
                            color: isCritical
                                ? AppColors.error
                                : AppColors.activeOrange,
                            size: AppSizes.w(22),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: AppSizes.w(14)),

                    // ── Title + Zone + Camera ────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Title with chevron
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: AppStyles.poppins(
                                    fontSize: AppSizes.fs14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: AppSizes.w(16),
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.h(5)),

                          // Zone
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/location_icon.png',
                                width: AppSizes.w(10),
                                height: AppSizes.h(10),
                                color: AppColors.grey900,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.location_on_outlined,
                                  size: AppSizes.w(12),
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(width: AppSizes.w(5)),
                              Text(
                                item.zone,
                                style: AppStyles.poppins(
                                  color: AppColors.grey,
                                  fontSize: AppSizes.fs12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.h(4)),

                          // Camera
                          Row(
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: AppSizes.w(11),
                                color: AppColors.grey900,
                              ),
                              SizedBox(width: AppSizes.w(5)),
                              Text(
                                item.camera,
                                style: AppStyles.poppins(
                                  color: AppColors.grey,
                                  fontSize: AppSizes.fs12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Escalation + Time ────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Escalates in ${item.escalationTime}',
                      style: AppStyles.poppins(
                        color: AppColors.grey900,
                        fontSize: AppSizes.fs14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: AppSizes.w(24),
                          color: AppColors.grey,
                        ),
                        SizedBox(width: AppSizes.w(3)),
                        Text(
                          item.timeAgo,
                          style: AppStyles.poppins(
                            color: AppColors.grey,
                            fontSize: AppSizes.fs12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.h(10)),

              // ── Progress Bar ─────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: item.progress,
                    backgroundColor: const Color(0xFFE8EDF2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCritical ? AppColors.error : AppColors.warning,
                    ),
                    minHeight: AppSizes.h(7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h(14)),

              // ── Acknowledge Button ───────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSizes.w(16), 0, AppSizes.w(16), AppSizes.h(16)),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSizes.h(44),
                  child: ElevatedButton.icon(
                    onPressed: isAcknowledged ? null : onAcknowledge,
                    icon: Icon(
                      isAcknowledged
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      size: AppSizes.fs16,
                    ),
                    label: Text(
                      isAcknowledged ? 'Acknowledged' : 'Acknowledge',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isAcknowledged ? AppColors.grey : AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      textStyle: AppStyles.poppins(
                        fontSize: AppSizes.fs14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Status Badge ─────────────────────────────────────
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w(10), vertical: AppSizes.h(6)),
            decoration: BoxDecoration(
              color: isCritical
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Text(
              item.status,
              style: AppStyles.poppins(
                color: isCritical ? AppColors.error : AppColors.warning,
                fontSize: AppSizes.fs12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}