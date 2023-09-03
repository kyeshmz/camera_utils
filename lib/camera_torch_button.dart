import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CameraTorchButton extends StatelessWidget {
  const CameraTorchButton({super.key, required this.onPressed, required this.isTorchOn});

  final VoidCallback onPressed;
  final bool isTorchOn;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: isTorchOn ? const Icon(Icons.flash_on_outlined) : const Icon(Icons.flash_off_outlined),
      color: Colors.white,
    );
  }
}
