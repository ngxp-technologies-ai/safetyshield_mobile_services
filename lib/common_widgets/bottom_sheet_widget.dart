import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_styles.dart';

class SafetyShieldBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? footer;
  final bool showHandle;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const SafetyShieldBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.footer,
    this.showHandle = true,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.w(22)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.w(8),
            0,
            AppSizes.w(8),
            AppSizes.h(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showHandle) ...[
                SizedBox(height: AppSizes.h(8)),
                Container(
                  width: AppSizes.w(52),
                  height: AppSizes.h(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(AppSizes.w(10)),
                  ),
                ),
                SizedBox(height: AppSizes.h(16)),
              ],
              if (title != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
                  child: Text(
                    title!,
                    style: AppStyles.poppins(
                      fontSize: AppSizes.fs16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.h(16)),
              ],
              Flexible(
                child: Padding(
                  padding: padding ?? EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
                  child: child,
                ),
              ),
              if (footer != null) ...[
                Container(
                  padding: EdgeInsets.only(
                    left: AppSizes.w(16),
                    right: AppSizes.w(16),
                    top: AppSizes.h(16),
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: footer!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget builder(BuildContext context),
    bool isScrollControlled = true,
    Color backgroundColor = Colors.transparent,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: builder,
    );
  }
}
