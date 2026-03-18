import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/zone/zone_controller.dart';
import '../model/zone/zone_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';

class ZoneRulesScreen extends StatefulWidget {
  const ZoneRulesScreen({super.key});

  @override
  State<ZoneRulesScreen> createState() => _ZoneRulesScreenState();
}

class _ZoneRulesScreenState extends State<ZoneRulesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ZoneController>().fetchZones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
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
          children: [
            Text(
              "Zone Rules",
              style: AppStyles.poppins(
                fontSize: AppSizes.fs16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            Text(
              "Read-only — Configured by Admin",
              style: AppStyles.poppins(
                fontSize: AppSizes.fs11,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.black),
          ),
        ],
      ),
      body: Consumer<ZoneController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage));
          }

          if (controller.zones.isEmpty) {
            return const Center(child: Text("No zones configured."));
          }

          return ListView.builder(
            padding: EdgeInsets.all(AppSizes.w(16)),
            itemCount: controller.zones.length,
            itemBuilder: (context, index) {
              return _ZoneExpansionCard(zone: controller.zones[index]);
            },
          );
        },
      ),
    );
  }
}

class _ZoneExpansionCard extends StatefulWidget {
  final ZoneModel zone;

  const _ZoneExpansionCard({required this.zone});

  @override
  State<_ZoneExpansionCard> createState() => _ZoneExpansionCardState();
}

class _ZoneExpansionCardState extends State<_ZoneExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.h(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },
          title: Text(
            "${widget.zone.name} — ${widget.zone.siteName}",
            style: AppStyles.poppins(
              fontSize: AppSizes.fs13,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: AppColors.grey,
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(AppSizes.w(16), 0, AppSizes.w(16), AppSizes.h(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFF0F0F0)),
                  SizedBox(height: AppSizes.h(12)),
                  
                  // Required PPE Chips
                  _SectionHeader(icon: Icons.personal_injury_outlined, title: "Required PPE"),
                  SizedBox(height: AppSizes.h(8)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.zone.ppeRequired.map((ppe) => _PpeChip(label: ppe)).toList(),
                  ),
                  SizedBox(height: AppSizes.h(20)),

                  // Restricted Activities
                  _SectionHeader(title: "Restricted Activities"),
                  SizedBox(height: AppSizes.h(8)),
                  ...widget.zone.restrictedActivities.map((activity) => _BulletPoint(text: activity)),
                  SizedBox(height: AppSizes.h(20)),

                  // Permits
                  _SectionHeader(title: "Permits"),
                  SizedBox(height: AppSizes.h(8)),
                  ...widget.zone.permits.map((permit) => _BulletPoint(text: permit)),
                  SizedBox(height: AppSizes.h(20)),

                  // Risks (Alert badges)
                  _SectionHeader(title: "Area Hazards"),
                  SizedBox(height: AppSizes.h(8)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.zone.risks.map((risk) => _RiskBadge(label: risk)).toList(),
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

class _SectionHeader extends StatelessWidget {
  final IconData? icon;
  final String title;

  const _SectionHeader({this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: AppColors.grey),
          SizedBox(width: 8),
        ],
        Text(
          title,
          style: AppStyles.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}

class _PpeChip extends StatelessWidget {
  final String label;

  const _PpeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    // Basic formatting for API labels like "hard_hat"
    final displayLabel = label.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1EBF5)),
      ),
      child: Text(
        displayLabel,
        style: AppStyles.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5B7A9A),
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(color: AppColors.grey, shape: BoxShape.circle),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppStyles.poppins(
                fontSize: 11,
                color: const Color(0xFF4B4B4B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  final String label;

  const _RiskBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F0),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFFCCC7)),
      ),
      child: Text(
        label,
        style: AppStyles.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.error,
        ),
      ),
    );
  }
}
