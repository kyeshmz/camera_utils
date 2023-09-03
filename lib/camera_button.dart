import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CameraButton extends HookWidget {
  const CameraButton({super.key, required this.onTapUp});

  final void Function() onTapUp;

  @override
  Widget build(BuildContext context) {
    final isTappedDown = useState(false);

    return GestureDetector(
      onTapDown: (details) {
        isTappedDown.value = true;
      },
      onTapUp: (details) {
        isTappedDown.value = false;
        onTapUp();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 30),
        width: 80,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 3, color: Colors.white),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FractionallySizedBox(
            heightFactor: isTappedDown.value ? 0.81 : 0.85,
            widthFactor: isTappedDown.value ? 0.81 : 0.85,
            child: Container(
              decoration: BoxDecoration(
                color: isTappedDown.value ? Colors.white.withOpacity(0.8) : Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
