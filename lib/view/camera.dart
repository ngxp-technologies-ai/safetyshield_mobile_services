import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_size.dart';
import 'package:safety_management/utils/app_styles.dart';

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
    CameraItem(id: 'CAM-A1', zone: 'Zone A — Foundation', isLive: true,  alertCount: 0),
    CameraItem(id: 'CAM-A2', zone: 'Zone A — Foundation', isLive: true,  alertCount: 0),
    CameraItem(id: 'CAM-A3', zone: 'Zone A — Foundation', isLive: true,  alertCount: 2),
    CameraItem(id: 'CAM-A4', zone: 'Zone A — Foundation', isLive: true,  alertCount: 1),
    CameraItem(id: 'CAM-B1', zone: 'Zone B — Scaffolding', isLive: true, alertCount: 1),
    CameraItem(id: 'CAM-B2', zone: 'Zone B — Scaffolding', isLive: true, alertCount: 0),
    CameraItem(id: 'CAM-C1', zone: 'Zone C — Crane Ops',  isLive: true,  alertCount: 0),
    CameraItem(id: 'CAM-C2', zone: 'Zone C — Crane Ops',  isLive: false, alertCount: 0),
    CameraItem(id: 'CAM-D1', zone: 'Zone D — Storage',    isLive: true,  alertCount: 0),
    CameraItem(id: 'CAM-D2', zone: 'Zone D — Storage',    isLive: true,  alertCount: 0),
    CameraItem(id: 'CAM-D3', zone: 'Zone D — Storage',    isLive: true,  alertCount: 0),
    CameraItem(id: 'CAM-D4', zone: 'Zone D — Electrical', isLive: true,  alertCount: 1),
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
        // ── Tab Bar ──────────────────────────────────────────
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
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.black : AppColors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Camera Grid ──────────────────────────────────────
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
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
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

    return Container(
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
          // ── Thumbnail area ─────────────────────────────────
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

          // ── Camera info ────────────────────────────────────
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
    );
  }
}