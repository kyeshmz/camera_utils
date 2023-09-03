import 'dart:developer';

import 'package:camera_utils/camera_state.dart';
import 'package:camera_utils/use_asynceffect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExposureSlider extends HookConsumerWidget {
  const ExposureSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraStateProvider);

    final minExposure = useState(0.1);

    final maxExposure = useState(1.1);

    useAsyncEffect(
      () async {
        if (cameraState.cameraController != null) {
          minExposure.value = await cameraState.cameraController!.getMaxExposureOffset();
          log(minExposure.value.toString());
          maxExposure.value = await cameraState.cameraController!.getMinExposureOffset();
          log(maxExposure.value.toString());
        }

        return null;
      },
      [cameraState.cameraController],
    );

    Future<void> changeExposure(double exposureVal) async {
      await cameraState.cameraController?.setExposureOffset(exposureVal);
    }

    return Slider(
      value: 0.3,
      onChanged: changeExposure,
      min: minExposure.value,
      max: maxExposure.value,
    );
  }
}
