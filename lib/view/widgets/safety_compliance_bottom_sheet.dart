import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_size.dart';
import 'package:safety_management/utils/app_styles.dart';
import 'package:safety_management/network/api_endpoints.dart';

class SafetyComplianceBottomSheet extends StatelessWidget {
  final Map<String, dynamic> item;

  const SafetyComplianceBottomSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.w(24)),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSizes.w(20),
        right: AppSizes.w(20),
        top: AppSizes.h(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.h(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: AppSizes.w(40),
              height: AppSizes.h(4),
              decoration: BoxDecoration(
                color: const Color(0xFFD0D5DD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: AppSizes.h(24)),
          
          Text(
            item['title'],
            style: AppStyles.poppins(
              fontSize: AppSizes.fs16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: AppSizes.h(16)),
          
          // Worker and Location
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(AppSizes.w(12)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Worker",
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs12,
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(height: AppSizes.h(4)),
                      Row(
                        children: [
                          Container(
                            width: AppSizes.w(32),
                            height: AppSizes.w(32),
                            decoration: BoxDecoration(
                              color: item['color'],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                item['initials'],
                                style: AppStyles.poppins(
                                  fontSize: AppSizes.fs12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.w(8)),
                          Expanded(
                            child: Text(
                              "Ravi Patel", // Hardcoded per design
                              style: AppStyles.poppins(
                                fontSize: AppSizes.fs13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w(16)),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(AppSizes.w(12)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs12,
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(height: AppSizes.h(4)),
                      Text(
                        item['subtitle'],
                        style: AppStyles.poppins(
                          fontSize: AppSizes.fs13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppSizes.h(20)),
          
          // Description
          Container(
            padding: EdgeInsets.all(AppSizes.w(12)),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs12,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  item['subtitle'],
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  item['timeAgo'],
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.h(20)),
          
          // Evidence Photo
          if (item['snapshotUrl'] != null && item['snapshotUrl'].toString().isNotEmpty)
            Container(
              width: double.infinity,
              height: AppSizes.h(200),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFD0D5DD), // Light grey
                ),
                image: DecorationImage(
                  image: NetworkImage("${ApiEndpoint.baseUrl}${item['snapshotUrl']}"),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppSizes.h(20)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFD0D5DD), // Light grey
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, color: AppColors.grey, size: 16),
                  SizedBox(width: AppSizes.w(8)),
                  Text(
                    "Evidence Photo Placeholder",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: AppSizes.h(20)),
          
          // Recent Alerts Checkbox
          Row(
            children: [
              Icon(Icons.circle_outlined, color: AppColors.grey, size: 18),
              SizedBox(width: AppSizes.w(8)),
              Text(
                "Recent Alerts",
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs13,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(12)),
          
          // Coaching Feedback TextField
          TextField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Add coaching feedback for the worker...",
              hintStyle: AppStyles.poppins(
                fontSize: AppSizes.fs13,
                color: AppColors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              contentPadding: EdgeInsets.all(AppSizes.w(12)),
            ),
          ),
          SizedBox(height: AppSizes.h(24)),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Get Acknowledgment",
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
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check, size: 18, color: AppColors.white),
                  label: Text(
                    "Resolve Violation",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
