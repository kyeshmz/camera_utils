// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cameraStateHash() => r'636ee37eb65010c68abe64d68c65298c2d1f2bba';

/// See also [CameraState].
@ProviderFor(CameraState)
final cameraStateProvider =
    AutoDisposeNotifierProvider<CameraState, CameraStateModel>.internal(
  CameraState.new,
  name: r'cameraStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cameraStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CameraState = AutoDisposeNotifier<CameraStateModel>;
String _$cameraStateDescriptionHash() =>
    r'2e95cc867eea0cd62f764113931a9d245c91eef2';

/// See also [CameraStateDescription].
@ProviderFor(CameraStateDescription)
final cameraStateDescriptionProvider = AutoDisposeAsyncNotifierProvider<
    CameraStateDescription, List<CameraDescription>>.internal(
  CameraStateDescription.new,
  name: r'cameraStateDescriptionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cameraStateDescriptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CameraStateDescription
    = AutoDisposeAsyncNotifier<List<CameraDescription>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
