import 'dart:ffi';

import 'package:camera_utils/camera_button.dart';
import 'package:camera_utils/camera_flip_button.dart';
import 'package:camera_utils/camera_state.dart';
import 'package:camera_utils/camera_torch_button.dart';
import 'package:camera_utils/exposure_slider.dart';
import 'package:camera_utils/focus_circle.dart';
import 'package:camera_utils/use_asynceffect.dart';
import 'package:camera_utils/use_camera.dart';
import 'package:flutter/material.dart';

// import 'package:camera/camera.dart';

import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animation = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );

    useAnimation(animation);

    final useCamera = useCameraHook(ref);

    // Future<void> initializeCamera() async {
    //   final camera = await ref.watch(cameraStateProvider.future);
    //   log(camera.toString());
    //   final controller = CameraController(camera[cameraLensIndex.value], ResolutionPreset.max, enableAudio: false);
    //   await controller.initialize();
    //   cameraRef.value = controller;
    //   log('camera initialized ${cameraRef.value}');
    // }

    // useAsyncEffect(
    //   () async {
    //     await Permission.camera.request();
    //     await initializeCamera();

    //     return () {
    //       cameraRef.value!.dispose();
    //     };
    //   },
    //   [],
    // );
    // useEffect(
    //   () {
    //     log('cameraRef changed ${cameraRef.value}');
    //     return null;
    //   },
    //   [cameraRef.value],
    // );

    useEffect(
      () {
        log('cameraRef initialized ${useCamera.cameraState}');
        return null;
      },
      [useCamera.cameraState],
    );

    return Scaffold(
      // appBar: AppBar(),

      body: Column(
        children: [
          useCamera.cameraState?.value != null
              ? Stack(
                  children: [
                    CameraPreview(
                      useCamera.cameraState!,
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onVerticalDragStart: (details) {},
                            onVerticalDragEnd: (details) {
                              // useCamera.cameraState.exp
                            },
                            onLongPress: () async {
                              await useCamera.cameraState?.setExposureMode(ExposureMode.locked);
                            },
                            onScaleStart: (details) {
                              useCamera.onScaleStart();
                            },
                            onScaleUpdate: (details) async {
                              await useCamera.onScaleUpdate(details);
                            },
                            onScaleEnd: (details) {
                              // zoom.value = scaleFactor;
                              debugPrint('Gesture end');
                            },
                            onTapDown: (details) => useCamera.onViewFinderTap(details, constraints),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: useCamera.focusCirclePosition.dy - 20,
                      left: useCamera.focusCirclePosition.dx - 20,
                      child: FocusCircle(
                        isVisible: useCamera.showFocusCircleState.value,
                        onEnd: () async {
                          await Future.delayed(const Duration(seconds: 1), () {
                            useCamera.showFocusCircleState.value = false;
                          });
                        },
                      ),
                    ),
                    const Positioned(
                      bottom: 30,
                      child: ExposureSlider(),
                    ),
                  ],
                )
              : Container(),

          Expanded(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CameraTorchButton(
                      isTorchOn: useCamera.cameraState?.value.flashMode == FlashMode.torch,
                      onPressed: () async {
                        await animation.forward();
                        await useCamera.setCameraTorch();
                      },
                    ),
                    CameraButton(
                      onTapUp: () async {
                        await useCamera.onCameraCapture();
                      },
                    ),
                    CameraFlipButton(
                      onPressed: () async {
                        await useCamera.changeLens();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // GestureDetector(
          //   onTap: () {
          //     animation.forward(from: 0);
          //   },
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width,
          //     child: Stack(
          //       children: [
          //         ScannerAnimation(
          //           false,
          //           334,
          //           animation: animation,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ScannerAnimation extends AnimatedWidget {
  const ScannerAnimation(
    this.stopped,
    this.width, {
    super.key,
    required Animation<double> animation,
  }) : super(
          listenable: animation,
        );
  final bool stopped;
  final double width;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final scorePosition = (animation.value * 440) + 16;

    var color1 = const Color(0x5532CD32);
    var color2 = const Color(0x0032CD32);

    if (animation.status == AnimationStatus.reverse) {
      color1 = const Color(0x0032CD32);
      color2 = const Color(0x5532CD32);
    }

    return Positioned(
      bottom: scorePosition,
      left: 16,
      child: Opacity(
        opacity: stopped ? 0.0 : 1.0,
        child: Container(
          height: 60,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 0.9],
              colors: [color1, color2],
            ),
          ),
        ),
      ),
    );
  }
}
