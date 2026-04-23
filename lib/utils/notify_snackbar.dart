import 'package:flutter/material.dart';
import 'package:safety_management/utils/app_size.dart';
import 'package:safety_management/utils/app_styles.dart';
import '../../utils/app_colors.dart';

enum SnackBarType { success, fail }

class NotifySnackBar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message, [SnackBarType? type = SnackBarType.fail]) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: type == SnackBarType.success
            ? Colors.green
            : Colors.red,
        content: AnimatedSnackBarText(message: message, type: type),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class AnimatedSnackBarText extends StatefulWidget {
  final String message;
  final SnackBarType? type;

  const AnimatedSnackBarText({super.key, required this.message, this.type});

  @override
  State<AnimatedSnackBarText> createState() => _AnimatedSnackBarTextState();
}

class _AnimatedSnackBarTextState extends State<AnimatedSnackBarText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconFadeAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _iconFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.type == SnackBarType.success
        ? Icons.check_circle_outline
        : Icons.error_outline;

    return SlideTransition(
      position: _slideAnimation,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: _iconFadeAnimation,
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: Text(
                  widget.message,
                  style: AppStyles.poppins(
                    fontSize: AppSizes.fs13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
