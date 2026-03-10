import 'package:flutter/material.dart';
import '../utils/screen_size.dart';
import '../utils/app_size.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
        child: Column(
          children: [

            /// TOP APP BAR
            Container(
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding,
                  vertical: ScreenSize.height * 0.015,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Icon(Icons.menu, size: ScreenSize.width * 0.07),

                    Image.asset(
                      "assets/images/safety_shield_title.png",
                      height: ScreenSize.height * 0.035,
                    ),

                    Icon(Icons.search, size: ScreenSize.width * 0.07),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// GOOD MORNING CARD
                    _goodMorningCard(),

                    SizedBox(height: AppSizes.spaceMedium),

                    /// METRICS
                    _metricsRow(),

                    SizedBox(height: AppSizes.spaceMedium),

                    /// ASSIGNED ZONES HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Assigned Zones",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenSize.width * 0.045),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: ScreenSize.width * 0.035),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.spaceSmall),

                    /// ZONES GRID
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSizes.spaceSmall,
                      crossAxisSpacing: AppSizes.spaceSmall,
                      childAspectRatio: 1.3,
                      children: const [
                        ZoneCard(
                          title: "Foundation pit",
                          zone: "Zone A",
                          status: "Safe",
                          crew: 12,
                          alerts: 0,
                          color: Colors.green,
                        ),
                        ZoneCard(
                          title: "Scaffolding",
                          zone: "Zone B",
                          status: "Critical",
                          crew: 8,
                          alerts: 3,
                          color: Colors.red,
                        ),
                        ZoneCard(
                          title: "Crane Ops",
                          zone: "Zone C",
                          status: "Warning",
                          crew: 5,
                          alerts: 1,
                          color: Colors.orange,
                        ),
                        ZoneCard(
                          title: "Material Storage",
                          zone: "Zone D",
                          status: "Safe",
                          crew: 4,
                          alerts: 0,
                          color: Colors.green,
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.spaceMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// GOOD MORNING CARD
  Widget _goodMorningCard() {
    return Container(
      padding: EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning ☀️",
                    style: TextStyle(
                        fontSize: ScreenSize.width * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Jacob Santos",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: ScreenSize.width * 0.035),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "● On Shift",
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          ),
Divider(),
          SizedBox(height: AppSizes.spaceMedium),

          Container(
            padding: EdgeInsets.all(AppSizes.spaceSmall),
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Assigned Site", style: TextStyle(color: Colors.grey)),
                    Text("Metro Line 3",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Text("online since: 07:00",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// METRICS ROW
  Widget _metricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        MetricCard(
            icon: "assets/images/crew_icon.png", title: "Crew", count: "29"),
        MetricCard(
            icon: "assets/images/alert_icon.png", title: "Alert", count: "5"),
        MetricCard(
            icon: "assets/images/camera_icon.png", title: "Camera", count: "4"),
        MetricCard(
            icon: "assets/images/warning_icon.png",
            title: "Escalation",
            count: "1"),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  final String icon;
  final String title;
  final String count;

  const MetricCard(
      {super.key,
        required this.icon,
        required this.title,
        required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width * .2,
      padding: EdgeInsets.all(AppSizes.spaceSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset(icon, height: ScreenSize.height * 0.03),
          SizedBox(height: 5),
          Text(title),
          Text(
            count,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ZoneCard extends StatelessWidget {
  final String title;
  final String zone;
  final String status;
  final int crew;
  final int alerts;
  final Color color;

  const ZoneCard(
      {super.key,
        required this.title,
        required this.zone,
        required this.status,
        required this.crew,
        required this.alerts,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spaceSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/location_icon.png",
                  height: ScreenSize.height * 0.03),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),

          SizedBox(height: AppSizes.spaceSmall),

          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

          Text(zone, style: const TextStyle(color: Colors.grey)),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text("$crew"),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.notifications,
                      size: 16, color: Colors.red),
                  SizedBox(width: 4),
                  Text("$alerts"),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}