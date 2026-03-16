import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';
import '../utils/screen_size.dart';

class TasksAndWorkOrdersScreen extends StatelessWidget {
  const TasksAndWorkOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    final tasks = TaskWorkOrder.dummyData;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leadingWidth: AppSizes.w(55),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          splashRadius: AppSizes.w(20),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: AppSizes.w(22),
          ),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tasks & Work Orders",
              style: AppStyles.poppins(
                fontSize: AppSizes.fs15,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: AppSizes.h(1)),
            Text(
              "${tasks.length} tasks today",
              style: AppStyles.poppins(
                fontSize: AppSizes.fs12,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: AppSizes.w(20),
            icon: Icon(
              Icons.search,
              color: AppColors.black,
              size: AppSizes.w(22),
            ),
          ),
          SizedBox(width: AppSizes.w(4)),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          AppSizes.w(12),
          AppSizes.h(12),
          AppSizes.w(12),
          AppSizes.h(20),
        ),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSizes.h(10)),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return _TaskCompactCard(
            task: task,
            onTap: () => _showTaskDetailsBottomSheet(context, task),
          );
        },
      ),
    );
  }

  void _showTaskDetailsBottomSheet(BuildContext context, TaskWorkOrder task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskDetailsBottomSheet(task: task),
    );
  }
}

class _TaskCompactCard extends StatelessWidget {
  final TaskWorkOrder task;
  final VoidCallback onTap;

  const _TaskCompactCard({
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSizes.w(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.w(14)),
        child: Container(
          padding: EdgeInsets.all(AppSizes.w(12)),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.w(14)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: AppSizes.h(5)),
                    child: Container(
                      width: AppSizes.w(8),
                      height: AppSizes.w(8),
                      decoration: BoxDecoration(
                        color: task.priorityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.w(8)),
                  Expanded(
                    child: Text(
                      task.title,
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3A3A3A),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.w(8)),
                  Text(
                    task.code,
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFA0A0A0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h(8)),
              Padding(
                padding: EdgeInsets.only(left: AppSizes.w(16)),
                child: Wrap(
                  spacing: AppSizes.w(6),
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      task.zone,
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs12,
                        color: const Color(0xFF8C8C8C),
                      ),
                    ),
                    _DotDivider(),
                    Text(
                      task.statusLabel,
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs12,
                        color: task.statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _DotDivider(),
                    Text(
                      "${task.completedCount}/${task.steps.length} done",
                      style: AppStyles.poppins(
                        fontSize: AppSizes.fs12,
                        color: const Color(0xFF8C8C8C),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.h(12)),
              Padding(
                padding: EdgeInsets.only(left: AppSizes.w(16)),
                child: _TaskProgressBar(progress: task.progress),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskDetailsBottomSheet extends StatelessWidget {
  final TaskWorkOrder task;

  const TaskDetailsBottomSheet({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isCompleted = task.completedCount == task.steps.length;

    return Container(
      padding: EdgeInsets.only(top: AppSizes.h(8), bottom: bottomInset),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.w(24)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w(8)),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.w(16)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w(12),
                  AppSizes.h(10),
                  AppSizes.w(12),
                  AppSizes.h(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: AppSizes.h(5)),
                          child: Container(
                            width: AppSizes.w(8),
                            height: AppSizes.w(8),
                            decoration: BoxDecoration(
                              color: task.priorityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(8)),
                        Expanded(
                          child: Text(
                            task.title,
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3A3A3A),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(8)),
                        Text(
                          task.code,
                          style: AppStyles.poppins(
                            fontSize: AppSizes.fs12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFA0A0A0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(8)),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.w(16)),
                      child: Wrap(
                        spacing: AppSizes.w(6),
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            task.zone,
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs12,
                              color: const Color(0xFF8C8C8C),
                            ),
                          ),
                          _DotDivider(),
                          Text(
                            task.statusLabel,
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs12,
                              color: task.statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          _DotDivider(),
                          Text(
                            "${task.completedCount}/${task.steps.length} done",
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs12,
                              color: const Color(0xFF8C8C8C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.h(12)),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.w(16)),
                      child: _TaskProgressBar(progress: task.progress),
                    ),
                    SizedBox(height: AppSizes.h(14)),

                    Row(
                      children: [
                        Expanded(
                          child: _InfoBox(
                            icon: Icons.security_outlined,
                            label: "Required PPE",
                            value: task.requiredPpe,
                          ),
                        ),
                        SizedBox(width: AppSizes.w(8)),
                        Expanded(
                          child: _InfoBox(
                            icon: Icons.description_outlined,
                            label: "Permit",
                            value: task.permit,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(12)),

                    ...task.steps.map(
                          (step) => Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.h(8)),
                        child: _TaskStepTile(step: step),
                      ),
                    ),

                    SizedBox(height: AppSizes.h(4)),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSizes.w(10)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: const Color(0xFFE6E6E6)),
                        borderRadius: BorderRadius.circular(AppSizes.w(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "✧ AI Safety Note",
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF169AE6),
                            ),
                          ),
                          SizedBox(height: AppSizes.h(4)),
                          Text(
                            task.aiSafetyNote,
                            style: AppStyles.poppins(
                              fontSize: AppSizes.fs12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF4E4E4E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.h(12)),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE5E5E5)),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(AppSizes.w(8)),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.h(12),
                              ),
                              backgroundColor: const Color(0xFFF8F8F8),
                            ),
                            icon: Icon(
                              Icons.outbox_outlined,
                              size: AppSizes.w(16),
                              color: const Color(0xFF555555),
                            ),
                            label: Text(
                              "Report Delay",
                              style: AppStyles.poppins(
                                fontSize: AppSizes.fs12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF555555),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(10)),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCompleted
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFF169AE6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(AppSizes.w(8)),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.h(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isCompleted ? "Complete Task" : "Next Step",
                                  style: AppStyles.poppins(
                                    fontSize: AppSizes.fs12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                                ),
                                if (isCompleted) ...[
                                  SizedBox(width: AppSizes.w(6)),
                                  Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: AppSizes.w(16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w(10)),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(AppSizes.w(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: AppSizes.w(13),
                color: const Color(0xFF9D9D9D),
              ),
              SizedBox(width: AppSizes.w(4)),
              Text(
                label,
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs10,
                  color: const Color(0xFF9D9D9D),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(4)),
          Text(
            value,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskStepTile extends StatelessWidget {
  final TaskStep step;

  const _TaskStepTile({
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = step.isCompleted;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(10),
        vertical: AppSizes.h(11),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(AppSizes.w(8)),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle_outline
                : Icons.radio_button_unchecked,
            size: AppSizes.w(16),
            color: isCompleted
                ? const Color(0xFF2ED19C)
                : const Color(0xFF888888),
          ),
          SizedBox(width: AppSizes.w(8)),
          Expanded(
            child: Text(
              step.title,
              style: AppStyles.poppins(
                fontSize: AppSizes.fs12,
                fontWeight: FontWeight.w400,
                color: isCompleted
                    ? const Color(0xFF9A9A9A)
                    : const Color(0xFF555555),
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: const Color(0xFF9A9A9A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskProgressBar extends StatelessWidget {
  final double progress;

  const _TaskProgressBar({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.h(6),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(AppSizes.w(10)),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF169AE6),
            borderRadius: BorderRadius.circular(AppSizes.w(10)),
          ),
        ),
      ),
    );
  }
}

class _DotDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.w(4),
      height: AppSizes.w(4),
      decoration: const BoxDecoration(
        color: Color(0xFFBDBDBD),
        shape: BoxShape.circle,
      ),
    );
  }
}

enum TaskStatus {
  inProgress,
  pending,
  completed,
}

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.inProgress:
        return "In Progress";
      case TaskStatus.pending:
        return "Pending";
      case TaskStatus.completed:
        return "Completed";
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.inProgress:
        return const Color(0xFF169AE6);
      case TaskStatus.pending:
        return const Color(0xFF888888);
      case TaskStatus.completed:
        return const Color(0xFF22C55E);
    }
  }
}

class TaskStep {
  final String title;
  final bool isCompleted;

  const TaskStep({
    required this.title,
    required this.isCompleted,
  });
}

class TaskWorkOrder {
  final String id;
  final String code;
  final String title;
  final String zone;
  final TaskStatus status;
  final Color priorityColor;
  final String requiredPpe;
  final String permit;
  final String aiSafetyNote;
  final List<TaskStep> steps;

  const TaskWorkOrder({
    required this.id,
    required this.code,
    required this.title,
    required this.zone,
    required this.status,
    required this.priorityColor,
    required this.requiredPpe,
    required this.permit,
    required this.aiSafetyNote,
    required this.steps,
  });

  int get completedCount => steps.where((e) => e.isCompleted).length;

  double get progress => steps.isEmpty ? 0 : completedCount / steps.length;

  String get statusLabel => status.label;

  Color get statusColor => status.color;

  static List<TaskWorkOrder> get dummyData => const [
    TaskWorkOrder(
      id: "1",
      code: "T-001",
      title: "Scaffolding Safety Inspection",
      zone: "Zone B",
      status: TaskStatus.inProgress,
      priorityColor: Color(0xFFFF4D4F),
      requiredPpe: "Helmet, Harness, Vest",
      permit: "Valid – WH-2024-089",
      aiSafetyNote:
      "Common miss: Check coupling pins on ledger connections",
      steps: [
        TaskStep(
          title: "Check base plates & sole boards",
          isCompleted: true,
        ),
        TaskStep(
          title: "Inspect guardrails & toe boards",
          isCompleted: true,
        ),
        TaskStep(
          title: "Verify harness anchor points",
          isCompleted: true,
        ),
        TaskStep(
          title: "Photo documentation",
          isCompleted: false,
        ),
      ],
    ),
    TaskWorkOrder(
      id: "2",
      code: "T-002",
      title: "Crane Zone Perimeter Check",
      zone: "Zone C",
      status: TaskStatus.pending,
      priorityColor: Color(0xFFFF4D4F),
      requiredPpe: "Helmet, Safety Shoes",
      permit: "Pending Approval",
      aiSafetyNote:
      "Recheck exclusion barricades before crane movement begins",
      steps: [
        TaskStep(
          title: "Check barricade placement",
          isCompleted: false,
        ),
        TaskStep(
          title: "Verify warning signage",
          isCompleted: false,
        ),
        TaskStep(
          title: "Clear unauthorized access",
          isCompleted: false,
        ),
      ],
    ),
    TaskWorkOrder(
      id: "3",
      code: "T-003",
      title: "Material Storage Housekeeping",
      zone: "Zone D",
      status: TaskStatus.pending,
      priorityColor: Color(0xFFFF8A00),
      requiredPpe: "Helmet, Gloves, Vest",
      permit: "Valid – WH-2024-091",
      aiSafetyNote:
      "Watch for obstructed walkways and unstable stacked materials",
      steps: [
        TaskStep(
          title: "Clear loose packaging waste",
          isCompleted: true,
        ),
        TaskStep(
          title: "Re-stack exposed material pallets",
          isCompleted: true,
        ),
        TaskStep(
          title: "Mark emergency access route",
          isCompleted: true,
        ),
        TaskStep(
          title: "Final area photo documentation",
          isCompleted: false,
        ),
      ],
    ),
  ];
}