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
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.greyLight, width: 1),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final isSelected = _selectedTabIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 24),
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
                      fontSize: 14,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
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
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final item = alerts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
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
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header row ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 70, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Frame not.png icon box ───────────────
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/Frame not.png',
                          width: 28,
                          height: 28,
                          color: isCritical
                              ? AppColors.error
                              : AppColors.activeOrange,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.notifications_none,
                            color: isCritical
                                ? AppColors.error
                                : AppColors.activeOrange,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Zone
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: AppColors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.zone,
                                style: AppStyles.poppins(
                                  color: AppColors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),

                          // Camera
                          Row(
                            children: [
                              const Icon(
                                Icons.videocam_outlined,
                                size: 13,
                                color: AppColors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.camera,
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
                  ],
                ),
              ),

              // ── Escalation + Time ────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Escalates in ${item.escalationTime}',
                      style: AppStyles.poppins(
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 13,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.timeAgo,
                          style: AppStyles.poppins(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // ── Progress Bar (thick oval) ─────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: item.progress,
                    backgroundColor: const Color(0xFFE8EDF2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCritical ? AppColors.error : AppColors.warning,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Acknowledge Button ───────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isAcknowledged ? null : onAcknowledge,
                    icon: Icon(
                      isAcknowledged
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      size: 20,
                    ),
                    label: Text(
                      isAcknowledged ? 'Acknowledged' : 'Acknowledge',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isAcknowledged ? AppColors.grey : AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 0,
                      textStyle: AppStyles.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Status Badge (Critical / Warning) ───────────────
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isCritical
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Text(
              item.status,
              style: AppStyles.poppins(
                color: isCritical ? AppColors.error : AppColors.warning,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}