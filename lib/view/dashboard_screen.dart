import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/common_widgets/common_widgets.dart';
//  ADD THIS IMPORT
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/view/camera.dart';
import 'package:safety_management/view/profile.dart';
import 'package:safety_management/view/zonemap.dart';
import '../controller/auth/auth_controller.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';
import '../utils/screen_size.dart';
import 'alerts_screen.dart';
import 'ai_assistant_screen.dart';
import 'login_screen.dart';
import '../controller/alert/alert_controller.dart';
import '../controller/alert/alert_stats_controller.dart';
import '../controller/crew/my_crew_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  bool _hasAlerts = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertStatsController>().fetchAlertStats();
      context.read<MyCrewController>().fetchMyCrew();
    });
  }

  //  Pages mapped to each tab
  List<Widget> get _pages => [
    const _HomeTab(),
    const AlertsScreen(), //  REAL ALERTS SCREEN
    const CameraScreen(),
    const ZoneMapScreen(),
    const ProfileScreen(),
  ];

  String? get _appBarTitle {
    switch (_currentIndex) {
      case 1:
        return 'Alerts';
      case 2:
        return 'Camera';
      case 3:
        return 'Zone Map';
      case 4:
        return 'Profile';
      default:
        return null;
    }
  }

  String? _appBarSubtitle(BuildContext context) {
    final alertStats = context.read<AlertStatsController>().stats;
    switch (_currentIndex) {
      case 1:
        return '${alertStats.activeAlerts} Active  ${alertStats.criticalCount} Critical';
      case 2:
        return '8 cameras  4 with alerts';
      case 3:
        return 'Metro line 3  Station B4';
      default:
        return null;
    }
  }

  List<Widget>? get _appBarActions {
    switch (_currentIndex) {
      case 2:
        return [
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.black,
              size: AppSizes.spaceMedium,
            ),
            onPressed: () {},
          ),
        ];
      case 3:
        return [
          Image.asset(
            'assets/icons/Filter.png',
            width: AppSizes.w(50),
            height: AppSizes.h(40),
            color: AppColors.grey900,
          ),
        ];
      case 4:
        return [
          TextButton(
            onPressed: () => _showLogoutDialog(),
            child: Text(
              'Logout',
              style: AppStyles.poppins(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ];
      default:
        return null;
    }
  }

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: AppStyles.poppins(
              fontSize: AppSizes.fs15,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: AppStyles.poppins(
              fontSize: AppSizes.fs12,
              color: AppColors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancel',
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs12,
                  color: AppColors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                'Logout',
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      await _handleLogout();
    }
  }

  Future<void> _handleLogout() async {
    final authController = context.read<AuthController>();

    await authController.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget? get _appBarLeading {
    if (_currentIndex == 4) {
      return IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 26),
        onPressed: () => setState(() => _currentIndex = 0),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: const SafetyShieldDrawer(),
      appBar: SafetyShieldAppBar(
        title: _appBarTitle,
        subtitle: _appBarSubtitle(context),
        actions: _appBarActions,
        leading: _appBarLeading,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onSearchTap: _currentIndex == 0 ? () {} : null,
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: SafetyShieldBottomNavBar(
        currentIndex: _currentIndex,
        hasAlerts: _hasAlerts,
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              // Alerts tab
              _hasAlerts = false;
              context.read<AlertController>().fetchActiveAlerts();
              context.read<AlertStatsController>().fetchAlertStats();
            }
          });
        },
      ),
    );
  }
}

//  Rest of your existing widgets below (unchanged)

class _GoodMorningSection extends StatelessWidget {
  const _GoodMorningSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.cardPaddingLarge),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Good Morning",
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: AppSizes.space6),
                      Text("", style: TextStyle(fontSize: AppSizes.fs16)),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.space12,
                      vertical: AppSizes.space6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffDFF4E8),
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusXLarge,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: AppSizes.w(4),
                          backgroundColor: const Color(0xff2DB468),
                        ),
                        SizedBox(width: AppSizes.space6),
                        Text(
                          "On Shift",
                          style: AppStyles.poppins(
                            color: const Color(0xff2DB468),
                            fontSize: AppSizes.fs10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.space6),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: AppSizes.w(14),
                    color: Colors.grey,
                  ),
                  SizedBox(width: AppSizes.space6),
                  Text(
                    "Jacob Santos",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.space8),
              const Divider(),
              SizedBox(height: AppSizes.space8),
              Container(
                padding: EdgeInsets.all(AppSizes.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Assigned Site",
                          style: AppStyles.poppins(
                            fontSize: AppSizes.fs11,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: AppSizes.space4),
                        Text(
                          "Metro Line 3",
                          style: AppStyles.poppins(
                            fontSize: AppSizes.fs13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.space12,
                        vertical: AppSizes.space6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusXLarge,
                        ),
                      ),
                      child: Text(
                        "online since: 07:00",
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: AppSizes.space16,
          top: AppSizes.h(68),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AiAssistantScreen(),
                ),
              );
            },
            child: Container(
              width: AppSizes.w(40),
              height: AppSizes.w(40),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1A8FB5).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/ai_assistant.png', // ✅ your image path here
                  width: AppSizes.w(20),
                  height: AppSizes.w(20),

                  // ✅ removes if your image already has color
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer2<MyCrewController, AlertStatsController>(
      builder: (context, crewController, alertStatsController, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatCard(
              icon: "assets/images/crew_icon.png",
              title: "Crew",
              value: "${crewController.total}",
            ),
            _StatCard(
              icon: "assets/images/alert_icon.png",
              title: "Alert",
              value: "${alertStatsController.stats.activeAlerts}",
              iconColor: Colors.red,
            ),
            _StatCard(
              icon: "assets/images/camera_icon.png",
              title: "Camera",
              value: "4",
              showGreenDot: true,
            ),
            _StatCard(
              icon: "assets/images/warning_icon.png",
              title: "Critical",
              value: "${alertStatsController.stats.criticalCount}",
              iconColor: Colors.orange,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color iconColor;
  final bool showGreenDot;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = const Color(0xFF1F8FB5),
    this.showGreenDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.statCardWidth,
      height: AppSizes.statCardHeight,
      padding: EdgeInsets.symmetric(vertical: AppSizes.space12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Image.asset(icon, height: AppSizes.w(22), color: iconColor),
              if (showGreenDot)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: AppSizes.onlineDot,
                    height: AppSizes.onlineDot,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2DB468),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            title,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs11,
              color: Colors.black45,
            ),
          ),
          Text(
            value,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GoodMorningSection(),
          SizedBox(height: AppSizes.space12),
          const _StatsSection(),
          SizedBox(height: AppSizes.space12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Assigned Zones",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: AppSizes.space6),
                  Text(
                    "4 zones",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                "View All",
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F8FB5),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.space12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.space12,
            mainAxisSpacing: AppSizes.space12,
            childAspectRatio: ScreenSize.width < 360 ? 1.15 : 1.3,
            children: const [
              _ZoneCard(
                title: "Foundation pit",
                zone: "Zone A",
                status: "Safe",
                statusColor: Color(0xFF2DB468),
                crew: 12,
                alerts: 0,
              ),
              _ZoneCard(
                title: "Scaffolding",
                zone: "Zone B",
                status: "Critical",
                statusColor: Color(0xFFE53935),
                crew: 8,
                alerts: 3,
              ),
              _ZoneCard(
                title: "Crane Ops",
                zone: "Zone C",
                status: "Warning",
                statusColor: Color(0xFFFFB300),
                crew: 5,
                alerts: 1,
              ),
              _ZoneCard(
                title: "Material Storage",
                zone: "Zone D",
                status: "Safe",
                statusColor: Color(0xFF2DB468),
                crew: 4,
                alerts: 0,
              ),
            ],
          ),
          SizedBox(height: AppSizes.space20),
          const _TotalMetricsSection(),
          SizedBox(height: AppSizes.space20),
        ],
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final String title;
  final String zone;
  final String status;
  final Color statusColor;
  final int crew;
  final int alerts;

  const _ZoneCard({
    required this.title,
    required this.zone,
    required this.status,
    required this.statusColor,
    required this.crew,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/location_icon.png", height: 22),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppStyles.poppins(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          Text(
            zone,
            style: AppStyles.poppins(color: Colors.grey, fontSize: 12),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset("assets/images/crew_icon.png", height: 14),
                  const SizedBox(width: 4),
                  Text(
                    "$crew",
                    style: AppStyles.poppins(fontSize: AppSizes.fs10),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset("assets/images/alert_icon.png", height: 14),
                  const SizedBox(width: 4),
                  Text(
                    "$alerts",
                    style: AppStyles.poppins(fontSize: AppSizes.fs12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalMetricsSection extends StatelessWidget {
  const _TotalMetricsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TotalMetricsHeader(),
        SizedBox(height: 12),
        _MetricsCardsRow(),
        SizedBox(height: 12),
        _TrendChartCard(),
        SizedBox(height: 12),
        _AiInsightCard(),
      ],
    );
  }
}

class _TotalMetricsHeader extends StatelessWidget {
  const _TotalMetricsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Metrics",
          style: AppStyles.poppins(
            fontSize: AppSizes.fs14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "View All",
          style: AppStyles.poppins(
            fontSize: AppSizes.fs12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F8FB5),
          ),
        ),
      ],
    );
  }
}

class _MetricsCardsRow extends StatelessWidget {
  const _MetricsCardsRow();

  @override
  Widget build(BuildContext context) {
    final isSmall = ScreenSize.width < 360;

    if (isSmall) {
      return Column(
        children: const [
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  iconBg: Color(0xFFFFE5E8),
                  iconColor: Color(0xFFFF6B6B),
                  icon: Icons.notifications_none_rounded,
                  value: '14',
                  label: 'Total Alerts',
                  footer: '3 Critical',
                  footerColor: Color(0xFFE53935),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  iconBg: Color(0xFFE3F7EA),
                  iconColor: Color(0xFF39C67A),
                  icon: Icons.access_time_rounded,
                  value: '2m 34s',
                  label: 'Avg Ack time',
                  footer: ' 18%',
                  footerColor: Color(0xFF2DB468),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _MetricCard(
            iconBg: Color(0xFFFFF3D8),
            iconColor: Color(0xFFE0B100),
            icon: Icons.warning_amber_rounded,
            value: '1',
            label: 'Escalation',
            footer: '5 Prevented',
            footerColor: Color(0xFF13A8E8),
          ),
        ],
      );
    }

    return Consumer<AlertStatsController>(
      builder: (context, alertStatsController, _) {
        final stats = alertStatsController.stats;
        return Row(
          children: [
            Expanded(
              child: _MetricCard(
                iconBg: const Color(0xFFFFE5E8),
                iconColor: const Color(0xFFFF6B6B),
                icon: Icons.notifications_none_rounded,
                value: "${stats.activeAlerts}",
                label: 'Total Alerts',
                footer: '${stats.criticalCount} Critical',
                footerColor: const Color(0xFFE53935),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: _MetricCard(
                iconBg: Color(0xFFE3F7EA),
                iconColor: Color(0xFF39C67A),
                icon: Icons.access_time_rounded,
                value: '2m 34s',
                label: 'Avg Ack time',
                footer: ' 18%',
                footerColor: Color(0xFF2DB468),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: _MetricCard(
                iconBg: Color(0xFFFFF3D8),
                iconColor: Color(0xFFE0B100),
                icon: Icons.warning_amber_rounded,
                value: '1',
                label: 'Critical',
                footer: '5 Prevented',
                footerColor: Color(0xFF13A8E8),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String value;
  final String label;
  final String footer;
  final Color footerColor;

  const _MetricCard({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.value,
    required this.label,
    required this.footer,
    required this.footerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.space10,
        vertical: AppSizes.space10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.smallIconBox,
            height: AppSizes.smallIconBox,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppSizes.w(6)),
            ),
            child: Icon(icon, size: AppSizes.w(14), color: iconColor),
          ),
          SizedBox(height: AppSizes.space8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              height: 1,
            ),
          ),
          SizedBox(height: AppSizes.space6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs11,
              color: AppColors.grey,
            ),
          ),
          Text(
            footer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs11,
              fontWeight: FontWeight.w500,
              color: footerColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendChartCard extends StatelessWidget {
  const _TrendChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Trend Chart',
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF343434),
                  ),
                ),
              ),
              _LegendDot(color: const Color(0xFF0E9DE6), label: 'Alerts'),
              const SizedBox(width: 14),
              _LegendDot(color: const Color(0xFFFF5A5A), label: 'Escalations'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: AppSizes.chartHeight,
            child: CustomPaint(
              painter: _TrendChartPainter(),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF666666)),
        ),
      ],
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0;
    const rightPad = 8.0;
    const topPad = 8.0;
    const bottomPad = 28.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final labelStyle = const TextStyle(
      color: Color(0xFFA5A8AE),
      fontSize: 11,
      fontWeight: FontWeight.w400,
    );

    final dashPaint = Paint()
      ..color = const Color(0xFFD8DCE3)
      ..strokeWidth = 1;

    final dashedLabels = ['16', '12', '8', '4', '0'];
    for (int i = 0; i < 5; i++) {
      final y = topPad + (chartHeight / 4) * i;
      if (i < 4) {
        double startX = leftPad;
        while (startX < size.width - rightPad) {
          canvas.drawLine(
            Offset(startX, y),
            Offset(math.min(startX + 4, size.width - rightPad), y),
            dashPaint,
          );
          startX += 8;
        }
      }
      final tp = TextPainter(
        text: TextSpan(text: dashedLabels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - 7));
    }

    final xLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    for (int i = 0; i < xLabels.length; i++) {
      final x = leftPad + (chartWidth / 6) * i;
      final tp = TextPainter(
        text: TextSpan(text: xLabels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 18));
    }

    final blueValues = [8.8, 9.4, 7.1, 11.3, 8.0, 11.2, 9.4, 10.9, 16.0];
    final redValues = [4.0, 5.8, 5.5, 7.1, 8.0, 4.2, 6.1, 7.8, 7.0];

    final bluePath = _smoothPath(
      values: blueValues,
      width: chartWidth,
      height: chartHeight,
      leftPad: leftPad,
      topPad: topPad,
      maxValue: 16,
    );
    final redPath = _smoothPath(
      values: redValues,
      width: chartWidth,
      height: chartHeight,
      leftPad: leftPad,
      topPad: topPad,
      maxValue: 16,
    );

    canvas.drawPath(
      bluePath,
      Paint()
        ..color = const Color(0xFF109DE6)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawPath(
      redPath,
      Paint()
        ..color = const Color(0xFFFF5D5D)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  Path _smoothPath({
    required List<double> values,
    required double width,
    required double height,
    required double leftPad,
    required double topPad,
    required double maxValue,
  }) {
    final path = Path();
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = leftPad + (width / (values.length - 1)) * i;
      final y = topPad + height - ((values[i] / maxValue) * height);
      points.add(Offset(x, y));
    }
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      path.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AiInsightCard extends StatelessWidget {
  const _AiInsightCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AiAssistantScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: CustomPaint(painter: _SparklePatternPainter()),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Color(0xFF0EA5E9),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AI Insight',
                      style: AppStyles.poppins(
                        color: const Color(0xFF0EA5E9),
                        fontWeight: FontWeight.w700,
                        fontSize: AppSizes.fs15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs13,
                      height: 1.45,
                      color: const Color(0xFF5B5B5B),
                    ),
                    children: [
                      const TextSpan(
                        text: 'High PPE non-compliance trend detected near ',
                      ),
                      TextSpan(
                        text: 'Scaffolding Zone',
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs13,
                          color: const Color(0xFFFF8A00),
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                      const TextSpan(
                        text:
                            '. 3 helmet violations in the last 45 minutes. Consider a toolbox talk.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    _InsightTag(
                      text: 'PPE Compliance',
                      bgColor: Color(0xFF6CC3E8),
                    ),
                    SizedBox(width: 8),
                    _InsightTag(text: 'Zone B', bgColor: Color(0xFFF7A53A)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightTag extends StatelessWidget {
  final String text;
  final Color bgColor;

  const _InsightTag({required this.text, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SparklePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7EC8F0)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final points = <Offset>[
      const Offset(20, 18),
      const Offset(72, 22),
      const Offset(128, 18),
      const Offset(184, 20),
      const Offset(240, 18),
      const Offset(35, 64),
      const Offset(95, 72),
      const Offset(154, 68),
      const Offset(214, 72),
      const Offset(268, 66),
      const Offset(18, 112),
      const Offset(78, 118),
      const Offset(136, 112),
      const Offset(198, 118),
      const Offset(254, 110),
    ];

    for (final p in points) {
      _drawSparkle(canvas, p, paint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset c, Paint paint) {
    canvas.drawLine(Offset(c.dx - 5, c.dy), Offset(c.dx + 5, c.dy), paint);
    canvas.drawLine(Offset(c.dx, c.dy - 5), Offset(c.dx, c.dy + 5), paint);
    canvas.drawLine(
      Offset(c.dx - 3.5, c.dy - 3.5),
      Offset(c.dx + 3.5, c.dy + 3.5),
      paint,
    );
    canvas.drawLine(
      Offset(c.dx - 3.5, c.dy + 3.5),
      Offset(c.dx + 3.5, c.dy - 3.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
