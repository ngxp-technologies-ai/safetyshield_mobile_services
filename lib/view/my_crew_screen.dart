import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';
import '../utils/screen_size.dart';

class MyCrewScreen extends StatelessWidget {
  const MyCrewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    final List<CrewMember> crewList = CrewMember.dummyData;

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
              "${crewList.length} workers across assigned zones",
              style: AppStyles.poppins(
                fontSize: AppSizes.fs12,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: AppSizes.w(20),
            icon: Icon(
              Icons.search,
              color: AppColors.black,
              size: AppSizes.w(22),
            ),
          ),
          SizedBox(width: AppSizes.w(4)),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          AppSizes.w(12),
          AppSizes.h(6),
          AppSizes.w(12),
          AppSizes.h(16),
        ),
        itemCount: crewList.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSizes.h(10)),
        itemBuilder: (context, index) {
          final member = crewList[index];
          return CrewMemberCard(
            member: member,
            onTap: () => _showCrewDetailsBottomSheet(context, member),
          );
        },
      ),
    );
  }

  void _showCrewDetailsBottomSheet(BuildContext context, CrewMember member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CrewDetailsBottomSheet(member: member),
    );
  }
}

class CrewMemberCard extends StatelessWidget {
  final CrewMember member;
  final VoidCallback onTap;

  const CrewMemberCard({
    super.key,
    required this.member,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasIssue = member.recentAlertText != null;
    final Color statusBg = _statusBackground(member.shiftStatus);
    final Color statusText = _statusTextColor(member.shiftStatus);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSizes.w(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.w(14)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(
            left: AppSizes.w(12),
            // right: AppSizes.w(14), // <- your required right padding
            bottom: AppSizes.w(12),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.w(14)),
            color: AppColors.white,
          ),
          child: Stack(
            children: [

              /// CONTENT ROW
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: AppSizes.w(12)),
                    child: _CrewAvatar(initials: member.initials),
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
                                  member.name,
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
                            member.role,
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
                                  icon: Icons.location_on_outlined,
                                  text: member.zone,
                                ),
                                _InfoDivider(),
                                _InfoItem(
                                  icon: Icons.access_time,
                                  text: member.timeText,
                                ),
                                _InfoDivider(),
                                _InfoItem(
                                  icon: Icons.health_and_safety_outlined,
                                  text: member.ppeStatus,
                                  textColor: member.isPpeOk
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFFFF4D4F),
                                  iconColor: member.isPpeOk
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFFFF4D4F),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              /// STATUS BADGE
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
                    member.shiftStatus.label,
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs11,
                      fontWeight: FontWeight.w500,
                      color: statusText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusBackground(ShiftStatus status) {
    switch (status) {
      case ShiftStatus.active:
        return const Color(0xFFE5F7EA);
      case ShiftStatus.breakTime:
        return const Color(0xFFFFEAD8);
    }
  }

  Color _statusTextColor(ShiftStatus status) {
    switch (status) {
      case ShiftStatus.active:
        return Colors.green;
      case ShiftStatus.breakTime:
        return const Color(0xFFFF8A00);
    }
  }
}

class CrewDetailsBottomSheet extends StatelessWidget {
  final CrewMember member;

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
                          initials: member.initials,
                          size: AppSizes.w(40),
                          fontSize: AppSizes.fs14,
                        ),
                        SizedBox(width: AppSizes.w(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: AppStyles.poppins(
                                  fontSize: AppSizes.fs14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: AppSizes.h(2)),
                              Text(
                                "${member.role} • ${member.zone}",
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
                            value: member.shiftStatus.label,
                            label: "Status",
                            valueColor: member.shiftStatus == ShiftStatus.active
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFFF8A00),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(8)),
                        Expanded(
                          child: _DetailStatCard(
                            value: member.ppeStatusSheet,
                            label: "PPE",
                            valueColor: member.isPpeOk
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFFF4D4F),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(8)),
                        Expanded(
                          child: _DetailStatCard(
                            value: member.shiftDuration,
                            label: "Shift",
                            valueColor: const Color(0xFF3A3A3A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(18)),
                    _SectionHeader(
                      icon: Icons.workspace_premium_outlined,
                      title: "Certificate",
                    ),
                    SizedBox(height: AppSizes.h(10)),
                    Wrap(
                      spacing: AppSizes.w(8),
                      runSpacing: AppSizes.h(8),
                      children: member.certificates
                          .map((item) => _TagChip(text: item))
                          .toList(),
                    ),
                    SizedBox(height: AppSizes.h(18)),
                    Divider(
                      color: const Color(0xFFEAEAEA),
                      height: AppSizes.h(1),
                    ),
                    SizedBox(height: AppSizes.h(16)),
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
                        color: member.recentAlertText == null
                            ? const Color(0xFFE7F7EC)
                            : const Color(0xFFFFF1F0),
                        borderRadius: BorderRadius.circular(AppSizes.w(10)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              member.recentAlertText ?? "No recent violations",
                              style: AppStyles.poppins(
                                fontSize: AppSizes.fs12,
                                fontWeight: FontWeight.w500,
                                color: member.recentAlertText == null
                                    ? const Color(0xFF22C55E)
                                    : member.alertColor,
                              ),
                            ),
                          ),
                          Icon(
                            member.recentAlertText == null
                                ? Icons.check
                                : Icons.warning_amber_rounded,
                            size: AppSizes.w(16),
                            color: member.recentAlertText == null
                                ? const Color(0xFF22C55E)
                                : member.alertColor,
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

class _TagChip extends StatelessWidget {
  final String text;

  const _TagChip({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(12),
        vertical: AppSizes.h(6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF2FD),
        borderRadius: BorderRadius.circular(AppSizes.w(16)),
      ),
      child: Text(
        text,
        style: AppStyles.poppins(
          fontSize: AppSizes.fs11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2196F3),
        ),
      ),
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
        Text(
          text,
          style: AppStyles.poppins(
            fontSize: AppSizes.fs12,
            color: textColor ?? const Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }
}

class _InfoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.w(1),
      height: AppSizes.h(12),
      color: const Color(0xFFD9D9D9),
    );
  }
}

enum ShiftStatus {
  active,
  breakTime,
}

extension ShiftStatusX on ShiftStatus {
  String get label {
    switch (this) {
      case ShiftStatus.active:
        return "Active";
      case ShiftStatus.breakTime:
        return "Break";
    }
  }
}

class CrewMember {
  final String id;
  final String name;
  final String initials;
  final String role;
  final String zone;
  final String timeText;
  final String ppeStatus;
  final String ppeStatusSheet;
  final bool isPpeOk;
  final ShiftStatus shiftStatus;
  final String? recentAlertText;
  final Color alertColor;
  final String shiftDuration;
  final List<String> certificates;

  const CrewMember({
    required this.id,
    required this.name,
    required this.initials,
    required this.role,
    required this.zone,
    required this.timeText,
    required this.ppeStatus,
    required this.ppeStatusSheet,
    required this.isPpeOk,
    required this.shiftStatus,
    required this.recentAlertText,
    required this.alertColor,
    required this.shiftDuration,
    required this.certificates,
  });

  static List<CrewMember> get dummyData => const [
    CrewMember(
      id: "1",
      name: "Anil Sharma",
      initials: "AS",
      role: "Rigger",
      zone: "Zone C",
      timeText: "2m ago",
      ppeStatus: "PPK OK",
      ppeStatusSheet: "Compliant",
      isPpeOk: true,
      shiftStatus: ShiftStatus.active,
      recentAlertText: null,
      alertColor: Color(0xFFFF4D4F),
      shiftDuration: "6h 12m",
      certificates: ["Rigging Level 2", "First Aid"],
    ),
    CrewMember(
      id: "2",
      name: "Priya Desai",
      initials: "PD",
      role: "Electrician",
      zone: "Zone B",
      timeText: "8m ago",
      ppeStatus: "PPE Missing",
      ppeStatusSheet: "Missing",
      isPpeOk: false,
      shiftStatus: ShiftStatus.active,
      recentAlertText: "PPE Missing",
      alertColor: Color(0xFFFF4D4F),
      shiftDuration: "5h 03m",
      certificates: ["Electrical Safety", "First Aid"],
    ),
    CrewMember(
      id: "3",
      name: "Suresh Patil",
      initials: "SP",
      role: "Mason",
      zone: "Zone A",
      timeText: "Now",
      ppeStatus: "PPK OK",
      ppeStatusSheet: "Compliant",
      isPpeOk: true,
      shiftStatus: ShiftStatus.breakTime,
      recentAlertText: null,
      alertColor: Color(0xFFFF8A00),
      shiftDuration: "4h 28m",
      certificates: ["Masonry", "Tool Handling"],
    ),
    CrewMember(
      id: "4",
      name: "Kavita Nair",
      initials: "KN",
      role: "Safety Officer",
      zone: "Zone B",
      timeText: "Now",
      ppeStatus: "PPK OK",
      ppeStatusSheet: "Compliant",
      isPpeOk: true,
      shiftStatus: ShiftStatus.active,
      recentAlertText: null,
      alertColor: Color(0xFFFF4D4F),
      shiftDuration: "7h 02m",
      certificates: ["Safety Audit", "Emergency Response"],
    ),
    CrewMember(
      id: "5",
      name: "Raj Thakur",
      initials: "RT",
      role: "Crane Operator",
      zone: "Zone C",
      timeText: "1m ago",
      ppeStatus: "PPK OK",
      ppeStatusSheet: "Compliant",
      isPpeOk: true,
      shiftStatus: ShiftStatus.active,
      recentAlertText: "Fatigue",
      alertColor: Color(0xFFFF4D4F),
      shiftDuration: "8h 10m",
      certificates: ["Crane License", "First Aid"],
    ),
    CrewMember(
      id: "6",
      name: "Mohit Verma",
      initials: "MV",
      role: "Supervisor",
      zone: "Zone D",
      timeText: "5m ago",
      ppeStatus: "PPK OK",
      ppeStatusSheet: "Compliant",
      isPpeOk: true,
      shiftStatus: ShiftStatus.active,
      recentAlertText: null,
      alertColor: Color(0xFFFF4D4F),
      shiftDuration: "6h 45m",
      certificates: ["Site Supervision", "First Aid"],
    ),
  ];
}