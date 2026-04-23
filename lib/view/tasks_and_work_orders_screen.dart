import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_management/controller/task/task_controller.dart';
import 'package:safety_management/model/task/task_model.dart';
import 'package:safety_management/view/widgets/create_task_bottom_sheet.dart';
import 'package:safety_management/view/widgets/task_options_bottom_sheet.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';

class TasksAndWorkOrdersScreen extends StatefulWidget {
  const TasksAndWorkOrdersScreen({super.key});

  @override
  State<TasksAndWorkOrdersScreen> createState() => _TasksAndWorkOrdersScreenState();
}

class _TasksAndWorkOrdersScreenState extends State<TasksAndWorkOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tasks & Work Orders",
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Consumer<TaskController>(
                builder: (context, controller, _) {
                  return Text(
                    "${controller.tasks.length} total tasks",
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune, color: AppColors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.black),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Consumer<TaskController>(
              builder: (context, controller, _) {
                return TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: AppColors.black,
                  unselectedLabelColor: AppColors.grey,
                  indicatorColor: const Color(0xFF169AE6),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: AppStyles.poppins(
                    fontSize: AppSizes.fs13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: AppStyles.poppins(
                    fontSize: AppSizes.fs13,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: [
                    Tab(text: "ALL(${controller.getTasksByStatus(null).length})"),
                    Tab(text: "ACTIVE(${controller.getTasksByStatus('active').length})"),
                    Tab(text: "PENDING(${controller.getTasksByStatus('pending').length})"),
                    Tab(text: "ON HOLD(${controller.getTasksByStatus('on hold').length})"),
                    Tab(text: "COMPLETED(${controller.getTasksByStatus('completed').length})"),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateTaskBottomSheet(context),
          backgroundColor: const Color(0xFF169AE6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.add, color: AppColors.white),
        ),
        body: const TabBarView(
          children: [
            _TaskList(status: null),
            _TaskList(status: 'active'),
            _TaskList(status: 'pending'),
            _TaskList(status: 'on hold'),
            _TaskList(status: 'completed'),
          ],
        ),
      ),
    );
  }

  void _showCreateTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateTaskBottomSheet(),
    );
  }
}

class _TaskList extends StatelessWidget {
  final String? status;

  const _TaskList({this.status});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskController>().getTasksByStatus(status);

    if (tasks.isEmpty) {
      if (context.watch<TaskController>().isLoading) {
         return const Center(child: CircularProgressIndicator(color: Color(0xFF169AE6)));
      }
      return Center(
        child: Text(
          "No tasks found",
          style: AppStyles.poppins(color: AppColors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.w(16)),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSizes.h(8)),
      itemBuilder: (context, index) {
        return _TaskCard(task: tasks[index]);
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.name,
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101828),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _showTaskOptions(context, task),
                icon: const Icon(Icons.more_vert, size: 20, color: AppColors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Tag(
                label: task.priority.toUpperCase(),
                color: task.priorityColor,
                bgColor: task.priorityBgColor,
              ),
              const SizedBox(width: 8),
              _Tag(
                label: task.status.toUpperCase(),
                color: task.statusColor,
                bgColor: task.statusBgColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "Progress",
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs12,
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              // We'll use a dummy progress or calculate if available in data
              Text(
                "65%", 
                style: AppStyles.poppins(
                  fontSize: AppSizes.fs12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF101828),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _ProgressBar(progress: 0.65),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(label: "EST:", value: task.estimatedhours),
              const SizedBox(width: 12),
              _StatItem(label: "ACT:", value: "0h"), // Placeholder until ACT is in API
              const Spacer(),
              if (task.permitt != 'none')
                _PermitTag(status: task.permitt)
              else
                _StatItem(label: "Permit:", value: "—"),
            ],
          ),
        ],
      ),
    );
  }

  void _showTaskOptions(BuildContext context, TaskModel task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskOptionsBottomSheet(
        onEdit: () {
        },
        onDelete: () {
          if (task.id != null) {
            context.read<TaskController>().deleteTask(task.id!);
          }
        },
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const _Tag({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppStyles.poppins(
          fontSize: AppSizes.fs11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF169AE6),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppStyles.poppins(
            fontSize: AppSizes.fs11,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppStyles.poppins(
            fontSize: AppSizes.fs11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF344054),
          ),
        ),
      ],
    );
  }
}

class _PermitTag extends StatelessWidget {
  final String status;

  const _PermitTag({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFABEFC6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 12, color: Color(0xFF067647)),
          const SizedBox(width: 4),
          Text(
            status,
            style: AppStyles.poppins(
              fontSize: AppSizes.fs10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF067647),
            ),
          ),
        ],
      ),
    );
  }
}