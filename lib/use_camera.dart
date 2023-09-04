import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_utils/camera_state.dart';
import 'package:camera_utils/use_asynceffect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

CameraHook useCameraHook(WidgetRef ref) {
  final cameraState = useState<CameraController?>(null);

  final cameraLensIndex = useState(0);
  final zoom = useState<double>(1);
  final minZoom = useState<double?>(null);
  final maxZoom = useState<double?>(null);
  final minExposure = useState<double?>(null);
  final maxExposure = useState<double?>(null);
  final exposureStepSize = useState<double?>(null);
  const scaleFactor = 1;

  final showFocusCircle = useState(false);
  final focusCirclePosition = useState(const Offset(100, 0));
  final animation = useAnimationController(
    duration: const Duration(milliseconds: 1000),
  );

  void onScaleStart() {
    zoom.value = scaleFactor.toDouble();
  }

  Future<void> onScaleUpdate(ScaleUpdateDetails details) async {
    final scaleFactor = zoom.value * details.scale;
    if (scaleFactor < 1) {
      return;
    }
    await cameraState.value!.setZoomLevel(scaleFactor);
    log('Gesture updated $scaleFactor');
    debugPrint('Gesture updated');
  }

  Future<void> initializeCamera() async {
    final camera = await ref.watch(cameraStateDescriptionProvider.future);
    log(camera.toString());
    final controller = CameraController(camera[cameraLensIndex.value], ResolutionPreset.max, enableAudio: false);

    await controller.initialize();
    cameraState.value = controller;
    log('camera initialized ${cameraState.value}');
  }

  Future<void> changeLens() async {
    final camera = await ref.watch(cameraStateDescriptionProvider.future);
    log(camera.length.toString());
    if (cameraLensIndex.value + 1 == camera.length) {
      cameraLensIndex.value = 0;
    } else {
      cameraLensIndex.value = cameraLensIndex.value += 1;
    }
    await initializeCamera();
  }

  Future<File> onCameraCapture() async {
    try {
      await cameraState.value?.lockCaptureOrientation();
      final file = await cameraState.value?.takePicture();
      // we get the compressed version here  and we return to make sure
      print(file?.path);
      if (file == null) {
        throw Exception('picture fail');
      }
      return File(file.path);
    } on Exception catch (e) {
      log(e.toString(), error: e);
      rethrow;
    }
  }

  Future<void> onViewFinderTap(TapDownDetails details, BoxConstraints constraints) async {
    if (cameraState.value == null) {
      return;
    }
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );

    await cameraState.value!.setExposurePoint(offset);
    await cameraState.value!.setFocusPoint(offset);
    showFocusCircle.value = true;
    log('onViewFinderTap ${details.globalPosition}');
    focusCirclePosition.value = details.localPosition;
  }

  Future<void> setCameraTorch() async {
    if (cameraState.value?.value.flashMode == FlashMode.off) {
      await cameraState.value?.setFlashMode(FlashMode.torch);
    } else {
      await cameraState.value?.setFlashMode(FlashMode.off);
    }
  }

  Future<void> changeExposure(double exposureVal) async {
    if (cameraState.value != null) {
      await cameraState.value?.setExposureOffset(exposureVal);
    }
  }

  Future<void> changeZoom(double val) async {
    await cameraState.value?.setZoomLevel(val);
  }

  Future<void> initializeCameraParameters() async {
    minZoom.value = await cameraState.value?.getMinZoomLevel();
    maxZoom.value = await cameraState.value?.getMaxZoomLevel();
    minExposure.value = await cameraState.value?.getMinExposureOffset();
    maxExposure.value = await cameraState.value?.getMaxExposureOffset();
    exposureStepSize.value = await cameraState.value?.getExposureOffsetStepSize();
  }

  useAsyncEffect(
    () async {
      await Permission.camera.request();
      await initializeCamera();
      await initializeCameraParameters();
      return () {
        cameraState.value!.dispose();
      };
    },
    [],
  );

  return CameraHook(
    cameraState: cameraState.value,
    changeLens: changeLens,
    initializeCamera: initializeCamera,
    onCameraCapture: onCameraCapture,
    onViewFinderTap: onViewFinderTap,
    setCameraTorch: setCameraTorch,
    onScaleStart: onScaleStart,
    onScaleUpdate: onScaleUpdate,
    focusCirclePosition: focusCirclePosition.value,
    showFocusCircleState: showFocusCircle,
    zoomValue: zoom.value ?? 0,
    minZoom: minZoom.value ?? 0,
    maxZoom: maxZoom.value ?? 1,
    minExposure: minExposure.value ?? 0,
    maxExposure: maxExposure.value ?? 1,
    changeExposure: changeExposure,
    changeZoom: changeZoom,
  );
}

class CameraHook {
  CameraHook({
    required this.onScaleStart,
    required this.onScaleUpdate,
    required this.cameraState,
    required this.changeLens,
    required this.initializeCamera,
    required this.onCameraCapture,
    required this.onViewFinderTap,
    required this.setCameraTorch,
    required this.focusCirclePosition,
    required this.showFocusCircleState,
    required this.zoomValue,
    required this.minZoom,
    required this.maxZoom,
    required this.minExposure,
    required this.maxExposure,
    required this.changeExposure,
    required this.changeZoom,
  });

  final VoidCallback onScaleStart;

  final Future<void> Function(ScaleUpdateDetails) onScaleUpdate;

  final CameraController? cameraState;

  final Future<void> Function() changeLens;
  final Future<void> Function() initializeCamera;

  final Future<File> Function() onCameraCapture;
  final Future<void> Function(TapDownDetails, BoxConstraints) onViewFinderTap;

  final Future<void> Function() setCameraTorch;
  final Offset focusCirclePosition;
  final ValueNotifier<bool> showFocusCircleState;

  final double zoomValue;

  final double minZoom;
  final double maxZoom;
  final double minExposure;
  final double maxExposure;

  final Future<void> Function(double) changeExposure;
  final Future<void> Function(double) changeZoom;
}

// Future<Uint8List> compressFile(XFile xfile) async {
//   try {
//     final file = File(xfile.path);
//     final result = await FlutterImageCompress.compressWithFile(
//       file.absolute.path,
//       quality: 90,
//     );
//     if (result == null) {
//       throw Exception('failed to compress file');
//     }
//     return result;
//   } on Exception catch (e) {
//     log(e.toString());
//     throw Exception('failed to compress file');
//   }
// }
