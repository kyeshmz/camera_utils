import 'package:camera_utils/camera_button.dart';
import 'package:camera_utils/camera_state.dart';
import 'package:camera_utils/use_asynceffect.dart';
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
    final cameraRef = useState<CameraController?>(null);
    final cameraLensIndex = useState(0);
    final zoom = useState(1);
    const scaleFactor = 1;
    final showFocusCircle = useState(false);
    final focusCirclePosition = useState(const Offset(100, 0));
    final animation = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );

    useAnimation(animation);

    Future<void> initializeCamera() async {
      final camera = await ref.watch(cameraStateProvider.future);
      log(camera.toString());
      final controller = CameraController(camera[cameraLensIndex.value], ResolutionPreset.max, enableAudio: false);
      await controller.initialize();
      cameraRef.value = controller;
      log('camera initialized ${cameraRef.value}');
    }

    useAsyncEffect(
      () async {
        await Permission.camera.request();
        await initializeCamera();

        return () {
          cameraRef.value!.dispose();
        };
      },
      [],
    );
    // useEffect(
    //   () {
    //     log('cameraRef changed ${cameraRef.value}');
    //     return null;
    //   },
    //   [cameraRef.value],
    // );

    // useEffect(
    //   () {
    //     log('cameraRef initialized ${cameraRef.value?.value.isInitialized}');
    //     return null;
    //   },
    //   [cameraRef.value?.value],
    // );

    void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
      if (cameraRef.value == null) {
        return;
      }
      final offset = Offset(
        details.localPosition.dx / constraints.maxWidth,
        details.localPosition.dy / constraints.maxHeight,
      );
      cameraRef.value!.setExposurePoint(offset);
      cameraRef.value!.setFocusPoint(offset);

      showFocusCircle.value = true;
      log('onViewFinderTap ${details.globalPosition}');
      focusCirclePosition.value = details.localPosition;
    }

    Future<void> changeLens() async {
      //increment index

      final camera = await ref.watch(cameraStateProvider.future);
      log(camera.length.toString());
      if (cameraLensIndex.value + 1 == camera.length) {
        cameraLensIndex.value = 0;
      } else {
        cameraLensIndex.value = cameraLensIndex.value += 1;
      }
      await initializeCamera();
    }

    return Scaffold(
      // appBar: AppBar(),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 600,
            width: MediaQuery.of(context).size.width,
            child: cameraRef.value != null
                ? SizedBox(
                    height: 400,
                    child: Stack(
                      children: [
                        CameraPreview(
                          cameraRef.value!,
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onScaleStart: (details) {
                                  zoom.value = scaleFactor;
                                  // cameraRef.value.setZoomLevel(zoom)
                                },
                                onScaleUpdate: (details) async {
                                  final scaleFactor = zoom.value * details.scale;
                                  if (scaleFactor < 1) {
                                    return;
                                  }
                                  await cameraRef.value!.setZoomLevel(scaleFactor);
                                  log('Gesture updated $scaleFactor');
                                  debugPrint('Gesture updated');
                                },
                                onScaleEnd: (details) {
                                  // zoom.value = scaleFactor;
                                  debugPrint('Gesture end');
                                },
                                onTapDown: (details) => onViewFinderTap(details, constraints),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: focusCirclePosition.value.dy - 20,
                          left: focusCirclePosition.value.dx - 20,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: Text(cameraRef.value.toString()),
                  ),
          ),
          Container(
            color: Colors.black,
            height: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.photo_outlined),
                  color: Colors.white,
                ),
                CameraButton(
                  onTapUp: () {},
                ),
                IconButton(
                  onPressed: () {
                    if (cameraRef.value != null) {
                      cameraRef.value!.setFlashMode(FlashMode.torch);
                      // cameraRef.value!.setFlashMode(FlashMode.always);
                    }
                  },
                  icon: const Icon(Icons.flash_off_outlined),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () async {
                    if (cameraRef.value != null) {
                      await changeLens();
                    }
                  },
                  icon: const Icon(Icons.flip_camera_ios_outlined),
                  color: Colors.white,
                ),
              ],
            ),
          ),
          // ScannerAnimation(
          //   animation: animation,
          // ),
        ],
      ),
    );
  }
}

// The [ScannerAnimation] for drawing scanner animation that moving down.
// This is controlled by the animation value
class ScannerAnimation extends AnimatedWidget {
  const ScannerAnimation({
    super.key,
    required Animation<double> animation,
    this.scanningColor = Colors.blue,
    this.scanningHeightOffset = 0.4,
  }) : super(
          listenable: animation,
        );

  final Color? scanningColor;
  final double scanningHeightOffset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final scanningGradientHeight = constrains.maxHeight * scanningHeightOffset;
        final animation = listenable as Animation<double>;
        final value = animation.value;
        final scorePosition = (value * constrains.maxHeight * 2) - (constrains.maxHeight);

        final color = scanningColor ?? Colors.blue;

        return Stack(
          children: [
            Container(
              height: scanningGradientHeight,
              transform: Matrix4.translationValues(0, scorePosition, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.0,
                    0.2,
                    0.9,
                    0.95,
                    1,
                  ],
                  colors: [
                    color.withOpacity(0.05),
                    color.withOpacity(0.1),
                    color.withOpacity(0.4),
                    color,
                    color,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
