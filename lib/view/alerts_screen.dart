import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';
import '../utils/notify_snackbar.dart';
import '../utils/app_size.dart';
import '../controller/alert/alert_stats_controller.dart';

import '../model/alert/alert_model.dart';
import '../controller/alert/alert_controller.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  List<AlertModel> _getFilteredAlerts(AlertController controller) {
    if (_selectedTabIndex == 0) {
      return controller.activeAlerts;
    } else if (_selectedTabIndex == 1) {
      return controller.activeAlerts
          .where((a) => a.severity.toLowerCase() == 'critical')
          .toList();
    } else if (_selectedTabIndex == 2) {
      return controller.acknowledgedAlerts;
    }
    return [];
  }

  List<String> _getTabs(int activeCount, int ackCount, int criticalCount) {
    return [
      'Active($activeCount)',
      'Critical($criticalCount)',
      'Acknowledged($ackCount)',
    ];
  }

  void _onTabTapped(int index, AlertController alertController) {
    setState(() => _selectedTabIndex = index);
    if (index == 2) {
      alertController.fetchAcknowledgedAlerts();
    } else {
      alertController.fetchActiveAlerts(showLoader: false);
    }
  }

  void _acknowledgeAlert(
    AlertModel item,
    AlertController alertController,
  ) async {
    await alertController.acknowledgeAlert(item.id);
    NotifySnackBar.show(
      'Alert acknowledged successfully',
      SnackBarType.Success,
    );
    // Refresh stats to update tab counts and app bar subtitle
    if (mounted) {
      context.read<AlertStatsController>().fetchAlertStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertController>(
      builder: (context, alertController, _) {
        final alerts = _getFilteredAlerts(alertController);

        return Column(
          children: [
            //  Tab Bar
            Consumer<AlertStatsController>(
              builder: (context, alertStats, _) {
                final tabs = _getTabs(
                  alertStats.stats.activeAlerts,
                  alertStats.stats.acknowledgedToday,
                  alertStats.stats.criticalCount,
                );
                return Container(
                  height: AppSizes.h(48),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.greyLight, width: 1),
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.pagePadding,
                    ),
                    itemBuilder: (context, index) {
                      final isSelected = _selectedTabIndex == index;
                      return GestureDetector(
                        onTap: () => _onTabTapped(index, alertController),
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
                            tabs[index],
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs12,
                              fontWeight: isSelected
                                  ? FontWeight.w400
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.black
                                  : AppColors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            //  Alert List
            Expanded(
              child: alertController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : alerts.isEmpty
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
                            onAcknowledge: () =>
                                _acknowledgeAlert(item, alertController),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class AlertCard extends StatelessWidget {
  final AlertModel item;
  final VoidCallback onAcknowledge;

  const AlertCard({super.key, required this.item, required this.onAcknowledge});

  @override
  Widget build(BuildContext context) {
    final isCritical = item.severity.toLowerCase() == 'critical';
    final isAcknowledged = item.isAcknowledged;

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
              //  Header row
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w(16),
                  AppSizes.h(16),
                  AppSizes.w(76),
                  AppSizes.h(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Icon box
                    Container(
                      width: AppSizes.w(40),
                      height: AppSizes.w(40),
                      decoration: BoxDecoration(
                        color:
                            (isCritical
                                    ? AppColors.error
                                    : AppColors.activeOrange)
                                .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppSizes.w(10)),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/Frame not.png',
                          width: AppSizes.w(20),
                          height: AppSizes.w(20),
                          color: isCritical
                              ? AppColors.error
                              : AppColors.activeOrange,
                          errorBuilder: (_, __, ___) => Icon(
                            item.severity.toLowerCase() == 'critical'
                                ? Icons.notifications_none
                                : Icons.warning_amber_rounded,
                            color: isCritical
                                ? AppColors.error
                                : AppColors.activeOrange,
                            size: AppSizes.w(22),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: AppSizes.w(14)),

                    //  Title + Zone + Camera
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with chevron
                          Row(
                            children: [
                              Text(
                                item.violationTitle,
                                style: AppStyles.poppins(
                                  fontSize: AppSizes.fs12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: AppSizes.w(16),
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.h(5)),

                          // Zone (Using camera_id as fallback)
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
                                "Site 1", // Assuming Site 1 for now
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
                                item.cameraId,
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

              //  Escalation + Time
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Confidence: ${(item.confidence * 100).toStringAsFixed(1)}%',
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
                          item.timestamp.split('T').last.substring(0, 5),
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

              //  Progress Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: item.confidence,
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

              //  Acknowledge Button
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w(16),
                  0,
                  AppSizes.w(16),
                  AppSizes.h(16),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSizes.h(40),
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
                      backgroundColor: isAcknowledged
                          ? AppColors.grey
                          : AppColors.primary,
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

        //  Status Badge
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w(10),
              vertical: AppSizes.h(6),
            ),
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
              item.severity.toUpperCase(),
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
