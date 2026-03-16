import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/equipment/equipment_controller.dart';
import '../model/equipment/equipment_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';

class EquipmentsScreen extends StatelessWidget {
  const EquipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Equipments",
              style: AppStyles.poppins(
                fontSize: AppSizes.fs16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            Consumer<EquipmentController>(
              builder: (context, controller, child) {
                return Text(
                  "${controller.getCountForTab('All')} equipment units in zone",
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs11,
                    color: AppColors.grey,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: AppColors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.black),
          ),
        ],
      ),
      body: Consumer<EquipmentController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              // Tab Bar
              Container(
                height: AppSizes.h(45),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E5E5)),
                  ),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.tabs.length,
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
                  itemBuilder: (context, index) {
                    final tab = controller.tabs[index];
                    final isSelected = controller.selectedTabIndex == index;
                    final count = controller.getCountForTab(tab);
                    
                    return GestureDetector(
                      onTap: () => controller.setTabIndex(index),
                      child: Container(
                        margin: EdgeInsets.only(right: AppSizes.w(16)),
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
                          "$tab($count)",
                          style: AppStyles.poppins(
                            fontSize: AppSizes.fs12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppColors.black : AppColors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Equipment List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(AppSizes.w(16)),
                  itemCount: controller.filteredEquipments.length,
                  itemBuilder: (context, index) {
                    final equipment = controller.filteredEquipments[index];
                    return _EquipmentCard(equipment: equipment);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  final EquipmentModel equipment;

  const _EquipmentCard({required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.h(16)),
      padding: EdgeInsets.all(AppSizes.w(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSizes.w(40),
                height: AppSizes.w(40),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.build_outlined, color: AppColors.grey, size: 24),
              ),
              SizedBox(width: AppSizes.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${equipment.name} ${equipment.id}",
                          style: AppStyles.poppins(
                            fontSize: AppSizes.fs13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        _StatusBadge(status: equipment.status),
                      ],
                    ),
                    Text(
                      equipment.location,
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs11,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(12)),
          
          // Utilization
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Utilization",
                style: AppStyles.poppins(fontSize: AppSizes.fs11, color: AppColors.grey),
              ),
              Text(
                "${(equipment.utilization * 100).toInt()}%",
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(6)),
          LinearProgressIndicator(
            value: equipment.utilization,
            backgroundColor: const Color(0xFFE5E5E5),
            color: AppColors.primary,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          SizedBox(height: AppSizes.h(12)),
          
          // Info Row
          Row(
            children: [
              _InfoItem(
                icon: Icons.person_outline,
                text: equipment.operatorName ?? 'Unassigned',
              ),
              SizedBox(width: AppSizes.w(12)),
              _InfoItem(
                icon: Icons.access_time,
                text: equipment.runtimeToday ?? '--',
              ),
              if (equipment.alertCount > 0) ...[
                SizedBox(width: AppSizes.w(12)),
                _InfoItem(
                  icon: Icons.warning_amber_rounded,
                  text: "${equipment.alertCount} alerts",
                  color: AppColors.error,
                ),
              ],
            ],
          ),
          
          // Alert Banner
          if (equipment.alertCount > 0 && equipment.alertMessage != null) ...[
            SizedBox(height: AppSizes.h(12)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.w(10), vertical: AppSizes.h(8)),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F0),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFFCCC7)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 16),
                  SizedBox(width: AppSizes.w(8)),
                  Expanded(
                    child: Text(
                      equipment.alertMessage!,
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final EquipmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case EquipmentStatus.active:
        bgColor = const Color(0xFFE7F7EC);
        textColor = const Color(0xFF2DB468);
        label = "Active";
        break;
      case EquipmentStatus.idle:
        bgColor = const Color(0xFFFFF7E6);
        textColor = const Color(0xFFFAAD14);
        label = "Idle";
        break;
      case EquipmentStatus.maintenance:
        bgColor = const Color(0xFFF5F5F5);
        textColor = AppColors.grey;
        label = "Maintenance";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppStyles.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoItem({
    required this.icon,
    required this.text,
    this.color = AppColors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        SizedBox(width: AppSizes.w(4)),
        Text(
          text,
          style: AppStyles.poppins(
            fontSize: 11,
            color: color,
          ),
        ),
      ],
    );
  }
}
