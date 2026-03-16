import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_size.dart';
import 'package:safety_management/utils/app_styles.dart';
import 'package:safety_management/common_widgets/bottom_sheet_widget.dart';

class CameraItem {
  final String id;
  final String zone;
  final bool isLive;
  final int alertCount;
  final String? thumbnailAsset;

  const CameraItem({
    required this.id,
    required this.zone,
    this.isLive = true,
    this.alertCount = 0,
    this.thumbnailAsset,
  });
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int _selectedTab = 0;

  final List<CameraItem> _allCameras = const [
    CameraItem(
      id: 'CAM-A1',
      zone: 'Zone A  Foundation',
      isLive: true,
      alertCount: 0,
    ),
    CameraItem(
      id: 'CAM-A2',
      zone: 'Zone A  Foundation',
      isLive: true,
      alertCount: 0,
    ),
    CameraItem(
      id: 'CAM-A3',
      zone: 'Zone A  Foundation',
      isLive: true,
      alertCount: 2,
    ),
    CameraItem(
      id: 'CAM-A4',
      zone: 'Zone A  Foundation',
      isLive: true,
      alertCount: 1,
    ),
    CameraItem(
      id: 'CAM-B1',
      zone: 'Zone B  Scaffolding',
      isLive: true,
      alertCount: 1,
    ),
    CameraItem(
      id: 'CAM-B2',
      zone: 'Zone B  Scaffolding',
      isLive: true,
      alertCount: 0,
    ),
    CameraItem(
      id: 'CAM-C1',
      zone: 'Zone C  Crane Ops',
      isLive: true,
      alertCount: 0,
    ),
    CameraItem(
      id: 'CAM-C2',
      zone: 'Zone C  Crane Ops',
      isLive: false,
      alertCount: 0,
    ),
    CameraItem(
      id: 'CAM-D1',
      zone: 'Zone D  Storage',
      isLive: true,
      alertCount: 0,
    ),
    CameraItem(
      id: 'CAM-D2',
      zone: 'Zone D  Storage',
      isLive: true,
      alertCount: 0,
    ),
    CameraItem(
      id: 'CAM-D3',
      zone: 'Zone D  Storage',
      isLive: true,
      alertCount: 0,
    ),
    CameraItem(
      id: 'CAM-D4',
      zone: 'Zone D  Electrical',
      isLive: true,
      alertCount: 1,
    ),
  ];

  List<CameraItem> get _activeCameras =>
      _allCameras.where((c) => c.isLive).toList();

  List<CameraItem> get _alertCameras =>
      _allCameras.where((c) => c.alertCount > 0).toList();

  List<CameraItem> get _displayed =>
      _selectedTab == 0 ? _activeCameras : _alertCameras;

  List<String> get _tabs => [
    'Active camera(${_activeCameras.length})',
    'With Alerts(${_alertCameras.length})',
  ];

  @override
  Widget build(BuildContext context) {
    final cameras = _displayed;

    return Column(
      children: [
        //  Tab Bar
        Container(
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.greyLight, width: 1),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
            itemBuilder: (context, index) {
              final isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: Container(
                  margin: EdgeInsets.only(right: AppSizes.horizontalPadding),
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
                    _tabs[index],
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? AppColors.black : AppColors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        //  Camera Grid
        Expanded(
          child: cameras.isEmpty
              ? Center(
                  child: Text(
                    'No Cameras found',
                    style: AppStyles.poppins(color: AppColors.grey),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(AppSizes.cardPaddingLarge),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: cameras.length,
                  itemBuilder: (context, index) {
                    return _CameraCard(camera: cameras[index]);
                  },
                ),
        ),
      ],
    );
  }
}

class _CameraCard extends StatelessWidget {
  final CameraItem camera;

  const _CameraCard({required this.camera});

  @override
  Widget build(BuildContext context) {
    final hasAlert = camera.alertCount > 0;

    return GestureDetector(
      onTap: () => _showCameraDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: Border.all(
            color: hasAlert ? AppColors.error : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Thumbnail area
            Expanded(
              child: Stack(
                children: [
                  // Camera placeholder
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: camera.thumbnailAsset != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: Image.asset(
                              camera.thumbnailAsset!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 36,
                              color: Color(0xFFB0B7C3),
                            ),
                          ),
                  ),

                  // Alert count badge (top-left)
                  if (hasAlert)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${camera.alertCount}',
                          style: AppStyles.poppins(
                            fontSize: AppSizes.fs11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),

                  // Live badge (top-right)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFF6E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2DB468),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            camera.isLive ? 'Live' : 'Off',
                            style: AppStyles.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: camera.isLive
                                  ? const Color(0xFF2DB468)
                                  : AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //  Camera info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    camera.id,
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    camera.zone,
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs10,
                      color: AppColors.grey,
                    ),
                    maxLines: 2,
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

  void _showCameraDetails(BuildContext context) {
    SafetyShieldBottomSheet.show(
      context: context,
      builder: (context) => CameraDetailsBottomSheet(camera: camera),
    );
  }
}

class CameraDetailsBottomSheet extends StatelessWidget {
  final CameraItem camera;

  const CameraDetailsBottomSheet({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    final hasAlert = camera.alertCount > 0;
    return SafetyShieldBottomSheet(
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16), vertical: AppSizes.h(10)),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD1D1D1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
              ),
              child: Text(
                "Close",
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs13,
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
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
              ),
              child: Text(
                "Jump to Alerts",
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Camera Preview Card (Includes ID, Zone, and Status)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasAlert ? AppColors.error : const Color(0xFFE0E0E0),
                width: hasAlert ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Preview Area with Badges
                Container(
                  height: AppSizes.h(160),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                  ),
                  child: Stack(
                    children: [
                      // Placeholder Icon
                      const Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                      
                      // Alert dot badge (top-left)
                      if (hasAlert)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${camera.alertCount}',
                              style: AppStyles.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      // Live badge (top-right)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDFF6E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2DB468),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Live',
                                style: AppStyles.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2DB468),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom Info Area (ID and Zone)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(11)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        camera.id,
                        style: AppStyles.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        camera.zone,
                        style: AppStyles.poppins(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.h(16)),

          // Alert Info Banner
          if (hasAlert)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "${camera.alertCount} Active alerts",
                    style: AppStyles.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Tap \"Jump to Alerts\" to see details",
                    style: AppStyles.poppins(
                      fontSize: 10,
                      color: AppColors.error.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: AppSizes.h(20)),

          // Last 5 Events Section
          Text(
            "Last 5 Events",
            style: AppStyles.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: AppSizes.h(12)),
          ...List.generate(5, (index) {
            final events = [
              "No Helmet",
              "Motion Detected",
              "Proximity alert",
              "PPE Check",
              "Zone Entry"
            ];
            final times = ["2m ago", "8m ago", "14m ago", "22m ago", "30m ago"];
            
            return Padding(
              padding: EdgeInsets.only(bottom: AppSizes.h(8)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: AppColors.grey.withOpacity(0.6)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${events[index % events.length]} — ${times[index % times.length]}",
                        style: AppStyles.poppins(
                          fontSize: 12,
                          color: const Color(0xFF4B4B4B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
