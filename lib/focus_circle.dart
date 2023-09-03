import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FocusCircle extends HookWidget {
  const FocusCircle({super.key, required this.isVisible, required this.onEnd});

  final bool isVisible;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isVisible ? 1 : 0,
      child: AnimatedContainer(
        onEnd: onEnd,
        alignment: Alignment.center,
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 300),
        // height: 40,
        // width: 40,
        height: isVisible ? 40 : 70,
        width: isVisible ? 40 : 70,
        // transform: (isVisible
        //     ? (Matrix4.identity()
        //       ..translate(0.025 * 40, 0.025 * 40) // translate towards right and down
        //       ..scale(0.45, 0.45)) // scale with to 95% anchorred at topleft of the AnimatedContainer
        //     : Matrix4.identity()),

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}
