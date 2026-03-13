import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/controller/crew/my_crew_controller.dart';
import 'package:safety_management/model/crew/my_crew_response_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';
import '../utils/screen_size.dart';

class MyCrewScreen extends StatefulWidget {
  const MyCrewScreen({super.key});

  @override
  State<MyCrewScreen> createState() => _MyCrewScreenState();
}

class _MyCrewScreenState extends State<MyCrewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyCrewController>().fetchMyCrew();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Consumer<MyCrewController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leadingWidth: AppSizes.w(55),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              splashRadius: AppSizes.w(20),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.black,
                size: AppSizes.w(22),
              ),
            ),
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "My Crew",
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppSizes.h(1)),
                Text(
                  "${controller.total} workers across assigned zones",
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w(12),
                  AppSizes.h(8),
                  AppSizes.w(12),
                  AppSizes.h(8),
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search by employee ID or name",
                    hintStyle: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      color: AppColors.grey,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: controller.clearSearch,
                      icon: const Icon(Icons.close),
                    )
                        : null,
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w(12),
                      vertical: AppSizes.h(12),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.workers.isEmpty
                    ? Center(
                  child: Text(
                    "No crew members found",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs13,
                      color: AppColors.grey,
                    ),
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: () => controller.fetchMyCrew(
                    search: controller.searchController.text.trim().isEmpty
                        ? null
                        : controller.searchController.text.trim(),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.w(12),
                      AppSizes.h(6),
                      AppSizes.w(12),
                      AppSizes.h(16),
                    ),
                    itemCount: controller.workers.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSizes.h(10)),
                    itemBuilder: (context, index) {
                      final member = controller.workers[index];
                      return CrewMemberCard(
                        member: member,
                        onTap: () => _showCrewDetailsBottomSheet(
                          context,
                          member,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCrewDetailsBottomSheet(
      BuildContext context,
      CrewWorkerModel member,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CrewDetailsBottomSheet(member: member),
    );
  }
}

class CrewMemberCard extends StatelessWidget {
  final CrewWorkerModel member;
  final VoidCallback onTap;

  const CrewMemberCard({
    super.key,
    required this.member,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasIssue = member.recentAlerts.isNotEmpty;
    final Color statusBg = _statusBackground(member.status);
    final Color statusText = _statusTextColor(member.status);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSizes.w(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.w(14)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(
            left: AppSizes.w(12),
            bottom: AppSizes.w(12),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.w(14)),
            color: AppColors.white,
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: AppSizes.w(12)),
                    child: _CrewAvatar(initials: _getInitials(member.fullName)),
                  ),
                  SizedBox(width: AppSizes.w(12)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSizes.w(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  member.fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.poppins(
                                    fontSize: AppSizes.fs13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right, size: AppSizes.w(15)),
                            ],
                          ),
                          SizedBox(height: AppSizes.h(2)),
                          Text(
                            member.designation ??
                                member.department ??
                                "Not Available",
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey,
                            ),
                          ),
                          SizedBox(height: AppSizes.h(4)),
                          Padding(
                            padding: EdgeInsets.only(right: AppSizes.w(14)),
                            child: Wrap(
                              spacing: AppSizes.w(6),
                              runSpacing: AppSizes.h(4),
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                _InfoItem(
                                  icon: Icons.badge_outlined,
                                  text: member.employeeId ?? "--",
                                ),
                                _InfoDivider(),
                                _InfoItem(
                                  icon: Icons.work_outline,
                                  text: member.currentTask ?? "No task",
                                ),
                                _InfoDivider(),
                                _InfoItem(
                                  icon: Icons.health_and_safety_outlined,
                                  text: member.ppeCompliance ?? "Unknown",
                                  textColor: _ppeTextColor(member.ppeCompliance),
                                  iconColor: _ppeTextColor(member.ppeCompliance),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w(10),
                    vertical: AppSizes.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.w(8)),
                      topRight: Radius.circular(AppSizes.w(14)),
                    ),
                  ),
                  child: Text(
                    _statusLabel(member.status),
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs11,
                      fontWeight: FontWeight.w500,
                      color: statusText,
                    ),
                  ),
                ),
              ),
              if (hasIssue)
                Positioned(
                  left: AppSizes.w(56),
                  bottom: 0,
                  right: AppSizes.w(14),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: AppSizes.w(15),
                        color: Colors.red,
                      ),
                      SizedBox(width: AppSizes.w(6)),
                      Expanded(
                        child: Text(
                          member.recentAlerts.first,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.poppins(
                            fontSize: AppSizes.fs12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '--';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'break':
        return 'Break';
      default:
        return status;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFFE5F7EA);
      case 'break':
        return const Color(0xFFFFEAD8);
      default:
        return const Color(0xFFEFF1F4);
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'break':
        return const Color(0xFFFF8A00);
      default:
        return AppColors.grey;
    }
  }

  Color _ppeTextColor(String? ppe) {
    if (ppe == null) return AppColors.grey;
    final value = ppe.toLowerCase();
    if (value.contains('ok') || value.contains('compliant')) {
      return const Color(0xFF22C55E);
    }
    if (value.contains('missing') || value.contains('non')) {
      return const Color(0xFFFF4D4F);
    }
    return AppColors.grey;
  }
}

class CrewDetailsBottomSheet extends StatelessWidget {
  final CrewWorkerModel member;

  const CrewDetailsBottomSheet({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(top: AppSizes.h(8), bottom: bottomInset),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.w(22)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.w(8),
            0,
            AppSizes.w(8),
            AppSizes.h(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.w(12)),
                bottom: Radius.circular(AppSizes.w(12)),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w(16),
                  AppSizes.h(8),
                  AppSizes.w(16),
                  AppSizes.h(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: AppSizes.w(52),
                        height: AppSizes.h(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(AppSizes.w(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.h(16)),
                    Row(
                      children: [
                        _CrewAvatar(
                          initials: _getInitials(member.fullName),
                          size: AppSizes.w(40),
                          fontSize: AppSizes.fs14,
                        ),
                        SizedBox(width: AppSizes.w(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.fullName,
                                style: AppStyles.poppins(
                                  fontSize: AppSizes.fs14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: AppSizes.h(2)),
                              Text(
                                "${member.designation ?? 'Not Available'} • ${member.department ?? 'Not Available'}",
                                style: AppStyles.poppins(
                                  fontSize: AppSizes.fs11,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(14)),
                    Row(
                      children: [
                        Expanded(
                          child: _DetailStatCard(
                            value: member.status,
                            label: "Status",
                            valueColor: member.status.toLowerCase() == 'active'
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFFF8A00),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(8)),
                        Expanded(
                          child: _DetailStatCard(
                            value: member.ppeCompliance ?? "Unknown",
                            label: "PPE",
                            valueColor: _ppeTextColor(member.ppeCompliance),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(8)),
                        Expanded(
                          child: _DetailStatCard(
                            value: member.isCertified ? "Yes" : "No",
                            label: "Certified",
                            valueColor: member.isCertified
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFFF4D4F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(18)),
                    _SectionHeader(
                      icon: Icons.work_outline,
                      title: "Current Task",
                    ),
                    SizedBox(height: AppSizes.h(10)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.w(12),
                        vertical: AppSizes.h(12),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(AppSizes.w(10)),
                      ),
                      child: Text(
                        member.currentTask ?? "No task assigned",
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.h(18)),
                    _SectionHeader(
                      icon: Icons.shield_outlined,
                      title: "Recent Alerts",
                    ),
                    SizedBox(height: AppSizes.h(10)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.w(12),
                        vertical: AppSizes.h(12),
                      ),
                      decoration: BoxDecoration(
                        color: member.recentAlerts.isEmpty
                            ? const Color(0xFFE7F7EC)
                            : const Color(0xFFFFF1F0),
                        borderRadius: BorderRadius.circular(AppSizes.w(10)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              member.recentAlerts.isEmpty
                                  ? "No recent violations"
                                  : member.recentAlerts.first,
                              style: AppStyles.poppins(
                                fontSize: AppSizes.fs12,
                                fontWeight: FontWeight.w500,
                                color: member.recentAlerts.isEmpty
                                    ? const Color(0xFF22C55E)
                                    : Colors.red,
                              ),
                            ),
                          ),
                          Icon(
                            member.recentAlerts.isEmpty
                                ? Icons.check
                                : Icons.warning_amber_rounded,
                            size: AppSizes.w(16),
                            color: member.recentAlerts.isEmpty
                                ? const Color(0xFF22C55E)
                                : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '--';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Color _ppeTextColor(String? ppe) {
    if (ppe == null) return AppColors.grey;
    final value = ppe.toLowerCase();
    if (value.contains('ok') || value.contains('compliant')) {
      return const Color(0xFF22C55E);
    }
    if (value.contains('missing') || value.contains('non')) {
      return const Color(0xFFFF4D4F);
    }
    return AppColors.grey;
  }
}

class _DetailStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _DetailStatCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(8),
        vertical: AppSizes.h(8),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(AppSizes.w(10)),
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs13,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
          SizedBox(height: AppSizes.h(2)),
          Text(
            label,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.w(15),
          color: const Color(0xFF7B7B7B),
        ),
        SizedBox(width: AppSizes.w(6)),
        Text(
          title,
          style: AppStyles.poppins(
            fontSize: AppSizes.fs13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6A6A6A),
          ),
        ),
      ],
    );
  }
}

class _CrewAvatar extends StatelessWidget {
  final String initials;
  final double? size;
  final double? fontSize;

  const _CrewAvatar({
    required this.initials,
    this.size,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? AppSizes.w(44);

    return Container(
      width: avatarSize,
      height: avatarSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F2F4),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: AppStyles.poppins(
          fontSize: fontSize ?? AppSizes.fs13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF8B8E94),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;
  final Color? iconColor;

  const _InfoItem({
    required this.icon,
    required this.text,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSizes.w(14),
          color: iconColor ?? const Color(0xFF7C7C80),
        ),
        SizedBox(width: AppSizes.w(4)),
        Flexible(
          child: Text(
            text,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs12,
              color: textColor ?? const Color(0xFF8E8E93),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.w(1),
      height: AppSizes.h(12),
      color: const Color(0xFFD9D9D9),
    );
  }
}