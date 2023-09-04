import 'package:camera_utils/camera_state.dart';
import 'package:camera_utils/use_camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ZoomSlider extends HookConsumerWidget {
  const ZoomSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraHook = useCameraHook(ref);

    return Slider(
      value: cameraHook.zoomValue,
      onChangeEnd: (val) async {
        await cameraHook.changeZoom(val);
      },
      onChanged: (val) async {},
      min: cameraHook.minZoom,
      max: cameraHook.maxZoom,
    );
  }
}
