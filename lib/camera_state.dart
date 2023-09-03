import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_state.g.dart';
part 'camera_state.freezed.dart';

@freezed
class CameraStateModel with _$CameraStateModel {
  const factory CameraStateModel({
    CameraController? cameraController,
    required int cameraLensIndex,
  }) = _CameraStateModel;
}

@Riverpod()
class CameraState extends _$CameraState {
  @override
  CameraStateModel build() {
    return const CameraStateModel(cameraLensIndex: 0);
  }

  Future<void> initializeCamera() async {
    final camera = await ref.watch(cameraStateDescriptionProvider.future);
    log(camera.toString());
    final controller = CameraController(camera[state.cameraLensIndex], ResolutionPreset.max, enableAudio: false);
    await controller.initialize();
    state = state.copyWith(cameraController: controller);

    log('camera initialized ${state.cameraController}');
  }
}

@Riverpod()
class CameraStateDescription extends _$CameraStateDescription {
  @override
  Future<List<CameraDescription>> build() async {
    return availableCameras();
  }
}
