import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_styles.dart';

class TaskOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskOptionsBottomSheet({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD0D5DD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: Color(0xFF344054)),
            title: Text(
              "Edit",
              style: AppStyles.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF344054),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Color(0xFFF04438)),
            title: Text(
              "Delete",
              style: AppStyles.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFF04438),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
