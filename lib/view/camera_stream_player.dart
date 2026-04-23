import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:safety_management/utils/app_colors.dart';

class CameraStreamPlayer extends StatefulWidget {
  final String rtspUrl;

  const CameraStreamPlayer({super.key, required this.rtspUrl});

  @override
  State<CameraStreamPlayer> createState() => _CameraStreamPlayerState();
}


class _CameraStreamPlayerState extends State<CameraStreamPlayer> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.rtspUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isError = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 36),
            SizedBox(height: 8),
            Text('Failed to load stream', style: TextStyle(color: AppColors.grey)),
          ],
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
