// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CameraStateModel {
  CameraController? get cameraController => throw _privateConstructorUsedError;
  int get cameraLensIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CameraStateModelCopyWith<CameraStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraStateModelCopyWith<$Res> {
  factory $CameraStateModelCopyWith(
          CameraStateModel value, $Res Function(CameraStateModel) then) =
      _$CameraStateModelCopyWithImpl<$Res, CameraStateModel>;
  @useResult
  $Res call({CameraController? cameraController, int cameraLensIndex});
}

/// @nodoc
class _$CameraStateModelCopyWithImpl<$Res, $Val extends CameraStateModel>
    implements $CameraStateModelCopyWith<$Res> {
  _$CameraStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameraController = freezed,
    Object? cameraLensIndex = null,
  }) {
    return _then(_value.copyWith(
      cameraController: freezed == cameraController
          ? _value.cameraController
          : cameraController // ignore: cast_nullable_to_non_nullable
              as CameraController?,
      cameraLensIndex: null == cameraLensIndex
          ? _value.cameraLensIndex
          : cameraLensIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CameraStateModelCopyWith<$Res>
    implements $CameraStateModelCopyWith<$Res> {
  factory _$$_CameraStateModelCopyWith(
          _$_CameraStateModel value, $Res Function(_$_CameraStateModel) then) =
      __$$_CameraStateModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CameraController? cameraController, int cameraLensIndex});
}

/// @nodoc
class __$$_CameraStateModelCopyWithImpl<$Res>
    extends _$CameraStateModelCopyWithImpl<$Res, _$_CameraStateModel>
    implements _$$_CameraStateModelCopyWith<$Res> {
  __$$_CameraStateModelCopyWithImpl(
      _$_CameraStateModel _value, $Res Function(_$_CameraStateModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameraController = freezed,
    Object? cameraLensIndex = null,
  }) {
    return _then(_$_CameraStateModel(
      cameraController: freezed == cameraController
          ? _value.cameraController
          : cameraController // ignore: cast_nullable_to_non_nullable
              as CameraController?,
      cameraLensIndex: null == cameraLensIndex
          ? _value.cameraLensIndex
          : cameraLensIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_CameraStateModel implements _CameraStateModel {
  const _$_CameraStateModel(
      {this.cameraController, required this.cameraLensIndex});

  @override
  final CameraController? cameraController;
  @override
  final int cameraLensIndex;

  @override
  String toString() {
    return 'CameraStateModel(cameraController: $cameraController, cameraLensIndex: $cameraLensIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CameraStateModel &&
            (identical(other.cameraController, cameraController) ||
                other.cameraController == cameraController) &&
            (identical(other.cameraLensIndex, cameraLensIndex) ||
                other.cameraLensIndex == cameraLensIndex));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, cameraController, cameraLensIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CameraStateModelCopyWith<_$_CameraStateModel> get copyWith =>
      __$$_CameraStateModelCopyWithImpl<_$_CameraStateModel>(this, _$identity);
}

abstract class _CameraStateModel implements CameraStateModel {
  const factory _CameraStateModel(
      {final CameraController? cameraController,
      required final int cameraLensIndex}) = _$_CameraStateModel;

  @override
  CameraController? get cameraController;
  @override
  int get cameraLensIndex;
  @override
  @JsonKey(ignore: true)
  _$$_CameraStateModelCopyWith<_$_CameraStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}
