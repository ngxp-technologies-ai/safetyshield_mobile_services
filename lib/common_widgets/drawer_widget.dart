import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';
import 'package:safety_management/view/equipments_screen.dart';
import 'package:safety_management/view/my_crew_screen.dart';
import 'package:safety_management/view/shift_handover_screen.dart';
import 'package:safety_management/view/tasks_and_work_orders_screen.dart';

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
                  icon: Icons.group_outlined,
                  label: 'My crew',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyCrewScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.sync,
                  label: 'Shift Handover',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ShiftHandoverScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.assignment_outlined,
                  label: 'Tasks & Work Orders',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TasksAndWorkOrdersScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.build_outlined,
                  label: 'Equipment',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EquipmentsScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.description_outlined,
                  label: 'Daily Reports',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.settings_outlined,
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
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: AppColors.black, size: 24),
      title: Text(
        label,
        style: AppStyles.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
