import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CameraFlipButton extends StatelessWidget {
  const CameraFlipButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        onPressed();
      },
      icon: const Icon(Icons.flip_camera_ios_outlined),
      color: Colors.white,
    );
  }
}
