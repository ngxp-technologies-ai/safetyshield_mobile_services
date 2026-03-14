import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';
import '../utils/screen_size.dart';

class ShiftHandoverScreen extends StatelessWidget {
  const ShiftHandoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: AppSizes.w(22),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          'Shift Handover',
          style: AppStyles.poppins(
            fontSize: AppSizes.fs15,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit_outlined,
              color: AppColors.black,
              size: AppSizes.w(20),
            ),
          ),
          SizedBox(width: AppSizes.w(6)),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.w(14),
            AppSizes.h(12),
            AppSizes.w(14),
            AppSizes.h(14),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.w(12)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.w(14)),
                    border: Border.all(
                      color: const Color(0xFFECECEC),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _TopMetricCard(
                                image: AppImages.crewIcon,
                                iconColor: Color(0xFF169AE6),
                                title: 'Crew',
                                value: '29',
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _TopMetricCard(
                                image: AppImages.alertIcon,
                                iconColor: Color(0xFFFF4D4F),
                                title: 'Alert',
                                value: '5',
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _TopMetricCard(
                                image: AppImages.warningIcon,
                                iconColor: Color(0xFFFF9F1A),
                                title: 'Escalation',
                                value: '1',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.h(16)),

                        const _SectionTitle(
                          icon: Icons.groups_2_outlined,
                          iconColor: Color(0xFF169AE6),
                          title: 'Workforce Status',
                        ),
                        SizedBox(height: AppSizes.h(10)),

                        const _InfoRow(
                          label: 'Total Workers',
                          value: '29',
                        ),
                        const _DividerLine(),
                        const _InfoRow(
                          label: 'Contractors',
                          value: '10',
                        ),
                        const _DividerLine(),
                        const _InfoRow(
                          label: 'Absent',
                          value: '3',
                        ),
                        const _DividerLine(),
                        const _InfoRow(
                          label: 'Supervisor',
                          value: 'Jacob Santos',
                          isBoldValue: true,
                        ),

                        SizedBox(height: AppSizes.h(18)),

                        const _SectionTitle(
                          icon: Icons.shield_outlined,
                          iconColor: Color(0xFF169AE6),
                          title: 'Safety & Incidents',
                        ),
                        SizedBox(height: AppSizes.h(10)),

                        const _InfoRow(
                          label: 'Incidents',
                          value: '1',
                        ),
                        SizedBox(height: AppSizes.h(6)),
                        const _SubAlertText(
                          text: 'Minor slip near scaffolding',
                        ),
                        const _DividerLine(),

                        const _InfoRow(
                          label: 'Safety Violations',
                          value: '1',
                        ),
                        SizedBox(height: AppSizes.h(6)),
                        const _SubAlertText(
                          text: 'Helmet violation',
                        ),
                        const _DividerLine(),

                        const _InfoRow(
                          label: 'Near Miss',
                          value: '2',
                        ),
                        const _DividerLine(),

                        const _InfoRow(
                          label: 'Active Permits',
                          value: '5',
                        ),

                        SizedBox(height: AppSizes.h(18)),

                        const _SectionTitle(
                          icon: Icons.build_outlined,
                          iconColor: Color(0xFF169AE6),
                          title: 'Equipment & Operations',
                        ),
                        SizedBox(height: AppSizes.h(10)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h(12)),
              SizedBox(
                width: double.infinity,
                height: AppSizes.h(48),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF169AE6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.w(8)),
                    ),
                  ),
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: AppColors.white,
                    size: AppSizes.w(18),
                  ),
                  label: Text(
                    'Send Handover',
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
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
}

class _TopMetricCard extends StatelessWidget {
  final String image;
  final Color iconColor;
  final String title;
  final String value;

  const _TopMetricCard({
    required this.image,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(8),
        vertical: AppSizes.h(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.w(10)),
        border: Border.all(
          color: const Color(0xFFEAEAEA),
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            image,
            color: iconColor,
            width: AppSizes.w(18),
            height: AppSizes.w(18),
          ),
          SizedBox(height: AppSizes.h(6)),
          Text(
            title,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6E6E6E),
            ),
          ),
          SizedBox(height: AppSizes.h(2)),
          Text(
            value,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs15,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: AppSizes.w(18),
        ),
        SizedBox(width: AppSizes.w(8)),
        Text(
          title,
          style: AppStyles.poppins(
            fontSize: AppSizes.fs14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4A4A4A),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBoldValue;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isBoldValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h(8)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppStyles.poppins(
                fontSize: AppSizes.fs13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF757575),
              ),
            ),
          ),
          Text(
            value,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs13,
              fontWeight: isBoldValue ? FontWeight.w600 : FontWeight.w500,
              color: const Color(0xFF3C3C3C),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubAlertText extends StatelessWidget {
  final String text;

  const _SubAlertText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.h(6)),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: AppSizes.w(14),
            color: const Color(0xFFFF9F1A),
          ),
          SizedBox(width: AppSizes.w(4)),
          Expanded(
            child: Text(
              text,
              style: AppStyles.poppins(
                fontSize: AppSizes.fs11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFA0A0A0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFFF0F0F0),
    );
  }
}