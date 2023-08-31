import 'package:camera/camera.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_state.g.dart';

@riverpod
class CameraState extends _$CameraState {
  @override
  Future<List<CameraDescription>> build() async {
    return availableCameras();
  }
}
