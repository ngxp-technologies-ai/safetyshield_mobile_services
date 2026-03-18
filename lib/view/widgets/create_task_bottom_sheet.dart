import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/controller/crew/my_crew_controller.dart';
import 'package:safety_management/controller/task/task_controller.dart';
import 'package:safety_management/model/task/task_model.dart';
import 'package:safety_management/utils/app_size.dart';
import 'package:safety_management/utils/app_styles.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet({super.key});

  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _hoursController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _permitt = "No permit required";
  String _priority = "Medium";
  String _status = "Pending";
  String? _selectedWorkerId;

  final List<String> _permitOptions = [
    "No permit required",
    "Hot Work Permit",
    "Confined Space Permit",
    "Working at Height Permit",
    "Electrical Isolation Permit",
  ];

  final List<String> _priorityOptions = ["Low", "Medium", "High", "Critical"];

  final List<String> _statusOptions = [
    "Pending",
    "Active",
    "In Progress",
    "Completed",
    "On Hold",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _hoursController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final crewController = context.watch<MyCrewController>();
    final workers = crewController.workers;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.w(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create Task",
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Task Title
            _buildLabel("Task Title"),
            const SizedBox(height: 8),
            _buildTextField(_nameController, "e.g. Foundation Excavation - Grid E2"),
            
            const SizedBox(height: 16),
            
            // Priority Selection (Figma Style)
            _buildLabel("Priority"),
            const SizedBox(height: 8),
            Row(
              children: _priorityOptions.map((p) {
                final isSelected = _priority.toLowerCase() == p.toLowerCase();
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () => setState(() => _priority = p),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF169AE6) : const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            p,
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : const Color(0xFF667085),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Permit Dropdown (Replaced checkbox because user said "PERMIT MISSING")
            _buildLabel("Permit"),
            const SizedBox(height: 8),
            _buildDropdownContainer(
              DropdownButton<String>(
                isExpanded: true,
                value: _permitt,
                underline: const SizedBox(),
                items: _permitOptions.map((opt) {
                  return DropdownMenuItem<String>(
                    value: opt,
                    child: Text(
                      opt,
                      style: AppStyles.poppins(fontSize: AppSizes.fs14),
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _permitt = val!),
              ),
            ),

            const SizedBox(height: 16),
            
            // Estimated Hours
            _buildLabel("Estimated Hours"),
            const SizedBox(height: 8),
            _buildTextField(_hoursController, "Enter estimated hours", keyboardType: TextInputType.number),
            
            const SizedBox(height: 16),
            
            // Assign Workers
            _buildLabel("Assign Workers"),
            const SizedBox(height: 8),
            _buildDropdownContainer(
               DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedWorkerId,
                  underline: const SizedBox(),
                  hint: Text(
                    "Select workers",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs14,
                      color: const Color(0xFF667085),
                    ),
                  ),
                  items: workers.map((worker) {
                    return DropdownMenuItem<String>(
                      value: worker.id,
                      child: Text(
                        worker.fullName,
                        style: AppStyles.poppins(fontSize: AppSizes.fs14),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedWorkerId = val),
                ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            _buildLabel("Description"),
            const SizedBox(height: 8),
            _buildTextField(_descriptionController, "Task details and instructions", maxLines: 3),
            
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF2F4F7)),
            const SizedBox(height: 16),

            // Additional fields required by API
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Location / Grid"),
                      const SizedBox(height: 8),
                      _buildTextField(_locationController, "Enter location"),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Status"),
                      const SizedBox(height: 8),
                      _buildDropdownContainer(
                        DropdownButton<String>(
                          isExpanded: true,
                          value: _status,
                          underline: const SizedBox(),
                          items: _statusOptions.map((opt) {
                            return DropdownMenuItem<String>(
                              value: opt,
                              child: Text(
                                opt,
                                style: AppStyles.poppins(fontSize: AppSizes.fs14),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _status = val!),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 16, color: Color(0xFF344054)),
                    label: Text(
                      "Cancel",
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF344054),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFFD0D5DD)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.check, size: 16, color: Colors.white),
                    label: context.watch<TaskController>().isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                      "Save",
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF169AE6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppStyles.poppins(
        fontSize: AppSizes.fs14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF344054),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.poppins(
          fontSize: AppSizes.fs14,
          color: const Color(0xFF667085),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
      ),
    );
  }

  Widget _buildDropdownContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: DropdownButtonHideUnderline(child: child),
    );
  }

  void _saveTask() {
    if (_nameController.text.isEmpty) return;

    final newTask = TaskModel(
      name: _nameController.text,
      location: _locationController.text.isEmpty ? "General" : _locationController.text,
      permitt: _permitt == "No permit required" ? "none" : _permitt,
      priority: _priority.toLowerCase(),
      status: _status.toLowerCase(),
      estimatedhours: _hoursController.text.isEmpty ? "0h" : _hoursController.text,
      userId: _selectedWorkerId,
    );

    context.read<TaskController>().addTask(newTask).then((_) {
       if (mounted) Navigator.pop(context);
    });
  }
}
