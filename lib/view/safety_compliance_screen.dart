import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/common_widgets/app_bar_widget.dart';
import 'package:safety_management/common_widgets/bottom_sheet_widget.dart';
import 'package:safety_management/controller/alert/alert_controller.dart';
import 'package:safety_management/controller/alert/alert_stats_controller.dart';
import 'package:safety_management/controller/dashboard/dashboard_controller.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_size.dart';
import 'package:safety_management/utils/app_styles.dart';
import 'package:safety_management/view/widgets/safety_compliance_bottom_sheet.dart';

class SafetyComplianceScreen extends StatefulWidget {
  const SafetyComplianceScreen({super.key});

  @override
  State<SafetyComplianceScreen> createState() => _SafetyComplianceScreenState();
}

class _SafetyComplianceScreenState extends State<SafetyComplianceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertController>().fetchActiveAlerts();
      context.read<DashboardController>().fetchDashboardStats();
      context.read<AlertStatsController>().fetchAlertStats();
    });
  }

  String _timeAgo(String timestamp) {
    if (timestamp.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      final difference = DateTime.now().difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hrs ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} min ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  String _getInitials(String personId) {
    if (personId.toLowerCase() == 'unknown' || personId.isEmpty) {
      return 'UN';
    }
    return personId.substring(0, personId.length >= 2 ? 2 : 1).toUpperCase();
  }

  Color _getColorForSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppColors.error;
      case 'warning':
        return const Color(0xFFFDB022);
      default:
        return const Color(0xFFFDB022);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafetyShieldAppBar(
          title: "Safety & Compliance",
          subtitle: "Monitor and enforce safety in your zone",
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(20),
            vertical: AppSizes.h(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPI Grid
              Consumer2<DashboardController, AlertStatsController>(
                builder:
                    (context, dashController, alertStatsController, child) {
                      final dashStats = dashController.stats;
                      final alertStats = alertStatsController.stats;

                      final kpis = [
                        _KPIItem(
                          title: "PPE Compliance",
                          value: "${dashStats.safetyScore}%",
                          icon: Icons.shield_outlined,
                          color: const Color(0xFFFDB022),
                        ),
                        _KPIItem(
                          title: "Active Permits",
                          value: "${dashStats.tasksActive}",
                          icon: Icons.description_outlined,
                          color: const Color(0xFF12B76A),
                        ),
                        _KPIItem(
                          title: "Expired Permits",
                          value: "${dashStats.delayed}",
                          icon: Icons.error_outline,
                          color: const Color(0xFFF04438),
                        ),
                        _KPIItem(
                          title: "Near Misses",
                          value: "${alertStats.criticalCount}",
                          icon: Icons.warning_amber_rounded,
                          color: const Color(0xFFFDB022),
                        ),
                        _KPIItem(
                          title: "Violations",
                          value: "${alertStats.activeAlerts}",
                          icon: Icons.block,
                          color: const Color(0xFFF04438),
                        ),
                        _KPIItem(
                          title: "Coaching Notes",
                          value: "${alertStats.acknowledgedToday}",
                          icon: Icons.chat_bubble_outline,
                          color: AppColors.black,
                        ),
                      ];

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: AppSizes.h(8),
                          crossAxisSpacing: AppSizes.w(8),
                          childAspectRatio: 1.15,
                        ),
                        itemCount: kpis.length,
                        itemBuilder: (context, index) {
                          return _KPICard(kpi: kpis[index]);
                        },
                      );
                    },
              ),

              SizedBox(height: AppSizes.h(16)),

              // Recent Violations Header
              Row(
                children: [
                  Text(
                    "Recent Violations",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(width: AppSizes.w(8)),
                  Text(
                    "4 zones",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSizes.h(16)),

              // Violations List
              Consumer<AlertController>(
                builder: (context, alertController, child) {
                  if (alertController.isLoading &&
                      alertController.activeAlerts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final alerts = alertController.activeAlerts;

                  if (alerts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.h(24)),
                        child: Text(
                          "No recent violations",
                          style: AppStyles.poppins(color: AppColors.grey),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      final bColor = _getColorForSeverity(alert.severity);

                      final violationItem = _ViolationItem(
                        initials: _getInitials(alert.personId),
                        title: alert.violationTitle,
                        subtitle: alert.cameraId,
                        timeAgo: _timeAgo(alert.timestamp),
                        color: bColor,
                        snapshotUrl: alert.snapshotUrl,
                      );

                      return _ViolationCard(item: violationItem);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KPIItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _KPIItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _KPICard extends StatelessWidget {
  final _KPIItem kpi;

  const _KPICard({required this.kpi});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.h(10),
        horizontal: AppSizes.w(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(kpi.icon, color: kpi.color, size: 18),
          SizedBox(height: AppSizes.h(6)),
          Text(
            kpi.title,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs10,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.h(4)),
          Text(
            kpi.value,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs16,
              fontWeight: FontWeight.w700,
              color: kpi.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViolationItem {
  final String initials;
  final String title;
  final String subtitle;
  final String timeAgo;
  final Color color;
  final String? snapshotUrl;

  _ViolationItem({
    required this.initials,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.color,
    this.snapshotUrl,
  });
}

class _ViolationCard extends StatelessWidget {
  final _ViolationItem item;

  const _ViolationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SafetyShieldBottomSheet.show(
          context: context,
          builder: (context) => SafetyComplianceBottomSheet(
            item: {
              'title': item.title,
              'subtitle': item.subtitle,
              'initials': item.initials,
              'timeAgo': item.timeAgo,
              'color': item.color,
              'snapshotUrl': item.snapshotUrl,
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.h(10)),
        padding: EdgeInsets.all(AppSizes.w(12)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Initials Avatar
            Container(
              width: AppSizes.w(32),
              height: AppSizes.w(32),
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item.initials,
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSizes.w(10)),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppStyles.poppins(
                            fontSize: AppSizes.fs14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: AppStyles.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h(4)),
                  Text(
                    item.subtitle,
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
