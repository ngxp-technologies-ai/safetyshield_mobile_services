import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common_widgets/bottom_sheet_widget.dart';
import '../controller/equipment/equipment_controller.dart';
import '../model/equipment/equipment_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';

class EquipmentsScreen extends StatefulWidget {
  const EquipmentsScreen({super.key});

  @override
  State<EquipmentsScreen> createState() => _EquipmentsScreenState();
}

class _EquipmentsScreenState extends State<EquipmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentController>().fetchEquipment();
    });
  }

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
            onPressed: () => _showFilterSheet(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            icon: Image.asset(
              'assets/icons/Filter.png',
              width: 28,
              height: 28,
              color: AppColors.grey900,
            ),
          ),
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            icon: Image.asset(
              'assets/icons/search.png',
              width: 28,
              height: 28,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Consumer<EquipmentController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchEquipment(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Tab Bar
              Container(
                height: AppSizes.h(45),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
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
                            fontWeight: isSelected
                                ? FontWeight.w600
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
              ),

              // Equipment List
              Expanded(
                child: controller.filteredEquipments.isEmpty
                    ? Center(
                        child: Text(
                          "No equipment found",
                          style: AppStyles.poppins(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(AppSizes.w(16)),
                        itemCount: controller.filteredEquipments.length,
                        itemBuilder: (context, index) {
                          final equipment =
                              controller.filteredEquipments[index];
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
    return GestureDetector(
      onTap: () => _showEquipmentDetails(context, equipment),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Main card ──────────────────────────────────────────
          Container(
            margin: EdgeInsets.only(bottom: AppSizes.h(12)),
            padding: EdgeInsets.all(AppSizes.w(14)),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Equipment Icon
                    Container(
                      width: AppSizes.w(40),
                      height: AppSizes.w(40),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        "assets/images/crane.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: AppSizes.w(10)),

                    // Name + Subtitle (reserve space on right for badge)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 52),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    "${equipment.name} ${equipment.equipmentCode}",
                                    style: AppStyles.poppins(
                                      fontSize: AppSizes.fs13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.h(2)),
                            Text(
                              "${_formatType(equipment.equipmentType)} • ${equipment.zoneName ?? 'No zone'}",
                              style: AppStyles.poppins(
                                fontSize: AppSizes.fs11,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.h(14)),

                // Utilization Bar
                Row(
                  children: [
                    Text(
                      "Utilization",
                      style: AppStyles.poppins(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${(equipment.utilization * 100).toInt()}%",
                      style: AppStyles.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.h(6)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: equipment.utilization,
                    backgroundColor: const Color(0xFFE5E5E5),
                    color: const Color(0xFF36B5A0),
                    minHeight: 6,
                  ),
                ),
                SizedBox(height: AppSizes.h(12)),

                // Info Row
                Container(
                  padding: EdgeInsets.only(top: AppSizes.h(10)),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: AppColors.grey,
                      ),
                      SizedBox(width: AppSizes.w(4)),
                      Flexible(
                        child: Text(
                          equipment.operatorName ?? 'Unassigned',
                          style: AppStyles.poppins(
                            fontSize: 11,
                            color: AppColors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: AppSizes.w(14)),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.grey,
                      ),
                      SizedBox(width: AppSizes.w(4)),
                      Text(
                        equipment.runtimeToday,
                        style: AppStyles.poppins(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                      if (equipment.hoursToday > 0) ...[
                        SizedBox(width: AppSizes.w(14)),
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 14,
                          color: AppColors.error,
                        ),
                        SizedBox(width: AppSizes.w(4)),
                        Text(
                          "2 alerts",
                          style: AppStyles.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Alert Banner (only when alerts exist)
                if (equipment.hoursToday > 0) ...[
                  SizedBox(height: AppSizes.h(10)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w(10),
                      vertical: AppSizes.h(8),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFCCC7)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error,
                          size: 14,
                        ),
                        SizedBox(width: AppSizes.w(6)),
                        Text(
                          "2 proximity alerts today",
                          style: AppStyles.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Status badge pinned to top-right corner of card ────
          Positioned(
            top: 12,
            right: 0,
            child: _StatusBadge(status: equipment.status),
          ),
        ],
      ),
    );
  }

  String _formatType(String type) {
    return type
        .split('_')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }
}

// --- Filter Bottom Sheet ---
void _showFilterSheet(BuildContext context) {
  SafetyShieldBottomSheet.show(
    context: context,
    builder: (context) => const _EquipmentFilterSheet(),
  );
}

class _EquipmentFilterSheet extends StatefulWidget {
  const _EquipmentFilterSheet();

  @override
  State<_EquipmentFilterSheet> createState() => _EquipmentFilterSheetState();
}

class _EquipmentFilterSheetState extends State<_EquipmentFilterSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EquipmentController>(
      builder: (context, controller, child) {
        final types = controller.availableTypes;

        return SafetyShieldBottomSheet(
          title: "Type",
          footer: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.clearFilters(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Reset",
                    style: AppStyles.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w(12)),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Apply Filter",
                    style: AppStyles.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: types.map((type) {
              final isSelected = controller.selectedTypes.contains(type);
              return _FilterCheckboxRow(
                label: _formatType(type),
                isSelected: isSelected,
                onChanged: (_) => controller.toggleType(type),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _formatType(String type) {
    return type
        .split('_')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }
}

class _FilterCheckboxRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const _FilterCheckboxRow({
    required this.label,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.h(8)),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFD0D5DD),
                  width: 1.5,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            SizedBox(width: AppSizes.w(12)),
            Text(
              label,
              style: AppStyles.poppins(
                fontSize: 14,
                color: const Color(0xFF344054),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Equipment Details Bottom Sheet ---
void _showEquipmentDetails(BuildContext context, EquipmentModel equipment) {
  SafetyShieldBottomSheet.show(
    context: context,
    builder: (context) => _EquipmentDetailsSheet(equipment: equipment),
  );
}

class _EquipmentDetailsSheet extends StatelessWidget {
  final EquipmentModel equipment;

  const _EquipmentDetailsSheet({required this.equipment});

  @override
  Widget build(BuildContext context) {
    return SafetyShieldBottomSheet(
      padding: EdgeInsets.zero,
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.add_location, size: 16),
              label: Text(
                "View on map",
                style: AppStyles.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: Color(0xFFD0D5DD)),
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.h(12),
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.w(10)),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.settings, size: 14),
              label: Text(
                "Request maintenance",
                style: AppStyles.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.h(12),
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: AppSizes.w(36),
                  height: AppSizes.w(36),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    "assets/images/crane.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: AppSizes.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${equipment.name} ${equipment.equipmentCode}",
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        _formatType(equipment.equipmentType),
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: equipment.status),
              ],
            ),
            SizedBox(height: AppSizes.h(20)),

            // Info Grid
            Row(
              children: [
                Expanded(
                  child: _DetailCell(
                    icon: Icons.speed_outlined,
                    label: "Utilization",
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: equipment.utilization,
                              backgroundColor: const Color(0xFFE5E5E5),
                              color: const Color(0xFF36B5A0),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(equipment.utilization * 100).toInt()}%",
                          style: AppStyles.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.w(16)),
                Expanded(
                  child: _DetailCell(
                    icon: Icons.access_time,
                    label: "Hours today",
                    value: "${equipment.hoursToday}h",
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h(12)),
            Row(
              children: [
                Expanded(
                  child: _DetailCell(
                    icon: Icons.person_outline,
                    label: "Operator",
                    value: equipment.operatorName ?? "Unassigned",
                  ),
                ),
                SizedBox(width: AppSizes.w(16)),
                Expanded(
                  child: _DetailCell(
                    icon: Icons.location_on_outlined,
                    label: "Location",
                    value: equipment.zoneName ?? "No zone",
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h(20)),

            // Maintenance Schedule
            Row(
              children: [
                Icon(
                  Icons.event_note_outlined,
                  size: 16,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  "Maintenance schedule",
                  style: AppStyles.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h(10)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w(14),
                vertical: AppSizes.h(10),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last service",
                          style: AppStyles.poppins(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          "3 days ago",
                          style: AppStyles.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: const Color(0xFFE5E5E5),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: AppSizes.w(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Next due",
                            style: AppStyles.poppins(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          Text(
                            "In 4 days",
                            style: AppStyles.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h(20)),

            // Recent Alerts
            Row(
              children: [
                Icon(Icons.notifications_none, size: 16, color: AppColors.grey),
                const SizedBox(width: 6),
                Text(
                  "Recent Alerts",
                  style: AppStyles.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h(10)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w(12),
                vertical: AppSizes.h(10),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F0),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFCCC7)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "2 proximity alerts today",
                      style: AppStyles.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatType(String type) {
    return type
        .split('_')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }
}

// --- Shared Widgets ---
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

class _DetailCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? child;

  const _DetailCell({
    required this.icon,
    required this.label,
    this.value,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.grey),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppStyles.poppins(fontSize: 14, color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child ??
              Text(
                value ?? '--',
                style: AppStyles.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
        ],
      ),
    );
  }
}
