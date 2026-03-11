import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_colors.dart';
import 'package:safety_management/utils/app_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // ── Profile Header ───────────────────────────────
          Center(
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.greyLight,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/Group.png',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 48,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Name
                Text(
                  'Jacob Santos',
                  style: AppStyles.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),

                // Role + Zones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Site supervisor',
                      style: AppStyles.poppins(
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Zone A, B, C, D',
                      style: AppStyles.poppins(
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // On Shift + Edit profile row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // On Shift badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFF6E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'On Shift since ',
                            style: AppStyles.poppins(
                              fontSize: 12,
                              color: const Color(0xFF2DB468),
                            ),
                          ),
                          Text(
                            '07:00AM',
                            style: AppStyles.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2DB468),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Edit profile button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.greyLight, width: 1),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Edit profile',
                              style: AppStyles.poppins(
                                fontSize: 12,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.edit_outlined,
                                size: 14, color: AppColors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Account Section ──────────────────────────────
          _SectionHeader(label: 'Account'),
          _MenuCard(
            items: [
              _MenuItem(
                icon: Icons.person_outline,
                label: 'Manage Profile',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.lock_outline,
                label: 'Password & Security',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.rule,
                label: 'Zone Rules',
                onTap: () {},
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Preferences Section ──────────────────────────
          _SectionHeader(label: 'Preferences'),
          _MenuCard(
            items: [
              _MenuItem(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                trailing: 'Enabled',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.brightness_6_outlined,
                label: 'Theme',
                trailing: 'Light',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.translate,
                label: 'Language',
                trailing: 'English',
                onTap: () {},
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Section header label ─────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        label,
        style: AppStyles.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

// ── White card containing menu rows ─────────────────────────
class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }
}

// ── Individual menu row ──────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  final bool isLast;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.black),
                ),
                const SizedBox(width: 12),

                // Label
                Expanded(
                  child: Text(
                    label,
                    style: AppStyles.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),

                // Optional trailing value
                if (trailing != null) ...[
                  Text(
                    trailing!,
                    style: AppStyles.poppins(
                      fontSize: 13,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],

                const Icon(Icons.chevron_right,
                    size: 18, color: AppColors.grey),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 64,
            endIndent: 16,
            color: AppColors.greyLight,
          ),
      ],
    );
  }
}