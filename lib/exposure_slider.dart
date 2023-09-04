import 'dart:developer';

import 'package:camera_utils/camera_state.dart';
import 'package:camera_utils/use_asynceffect.dart';
import 'package:camera_utils/use_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExposureSlider extends HookConsumerWidget {
  const ExposureSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraHook = useCameraHook(ref);

    return Slider(
      value: 0.3,
      onChanged: (val) async {
        await cameraHook.changeExposure(val);
      },
      min: cameraHook.minExposure,
      max: cameraHook.maxExposure,
    );
  }
}
