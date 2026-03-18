import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';
import 'package:safety_management/view/equipments_screen.dart';
import 'package:safety_management/view/my_crew_screen.dart';
import 'package:safety_management/view/shift_handover_screen.dart';
import 'package:safety_management/view/tasks_and_work_orders_screen.dart';
import 'package:safety_management/view/zone_rules_screen.dart';
import 'package:safety_management/view/safety_compliance_screen.dart';

class SafetyShieldDrawer extends StatelessWidget {
  const SafetyShieldDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          //  Header Section
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/icons/sa_logo.png',
                    height: 48,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.shield,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F4F7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.greyLight),

          //  Main Menu Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Text(
                    'Main Menu',
                    style: AppStyles.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                _DrawerItem(
                  assetIcon: 'assets/icons/users_drawer.png',
                  label: 'My crew',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyCrewScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  assetIcon: 'assets/icons/shifthandover.png',
                  label: 'Shift Handover',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ShiftHandoverScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  assetIcon: 'assets/icons/task&workorders.png',
                  label: 'Tasks & Work Orders',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TasksAndWorkOrdersScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  assetIcon: 'assets/icons/safety&compliance.png',
                  label: 'Safety & Compliance',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SafetyComplianceScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  assetIcon: 'assets/icons/zonerules.png',
                  label: 'Zone Rules',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ZoneRulesScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  assetIcon: 'assets/icons/equipment.png',
                  label: 'Equipment',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EquipmentsScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  assetIcon: 'assets/icons/dailyreports.png',
                  label: 'Daily Reports',
                  onTap: () {},
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, indent: 24, endIndent: 24, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 12),

                _DrawerItem(
                  assetIcon: 'assets/icons/setings_dawer.png',
                  label: 'Settings',
                  onTap: () {},
                ),
              ],
            ),
          ),

          //  Footer Section
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Need Help?',
                style: AppStyles.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF13A8E8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String? assetIcon;
  final IconData? icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    this.assetIcon,
    this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: assetIcon != null
          ? Image.asset(
              assetIcon!,
              width: 24,
              height: 24,
              color: AppColors.black,
              errorBuilder: (_, __, ___) => Icon(
                icon ?? Icons.circle_outlined,
                color: AppColors.black,
                size: 24,
              ),
            )
          : Icon(icon ?? Icons.circle_outlined, color: AppColors.black, size: 24),
      title: Text(
        label,
        style: AppStyles.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF344054),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
