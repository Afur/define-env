// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ConfigurationTearOff {
  const _$ConfigurationTearOff();

  _Configuration call(
      {required String name,
      String? sourceFilePath,
      required String startupFilePath}) {
    return _Configuration(
      name: name,
      sourceFilePath: sourceFilePath,
      startupFilePath: startupFilePath,
    );
  }
}

/// @nodoc
const $Configuration = _$ConfigurationTearOff();

/// @nodoc
mixin _$Configuration {
  String get name => throw _privateConstructorUsedError;
  String? get sourceFilePath => throw _privateConstructorUsedError;
  String get startupFilePath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConfigurationCopyWith<Configuration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigurationCopyWith<$Res> {
  factory $ConfigurationCopyWith(
          Configuration value, $Res Function(Configuration) then) =
      _$ConfigurationCopyWithImpl<$Res>;
  $Res call({String name, String? sourceFilePath, String startupFilePath});
}

/// @nodoc
class _$ConfigurationCopyWithImpl<$Res>
    implements $ConfigurationCopyWith<$Res> {
  _$ConfigurationCopyWithImpl(this._value, this._then);

  final Configuration _value;
  // ignore: unused_field
  final $Res Function(Configuration) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? sourceFilePath = freezed,
    Object? startupFilePath = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sourceFilePath: sourceFilePath == freezed
          ? _value.sourceFilePath
          : sourceFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      startupFilePath: startupFilePath == freezed
          ? _value.startupFilePath
          : startupFilePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$ConfigurationCopyWith<$Res>
    implements $ConfigurationCopyWith<$Res> {
  factory _$ConfigurationCopyWith(
          _Configuration value, $Res Function(_Configuration) then) =
      __$ConfigurationCopyWithImpl<$Res>;
  @override
  $Res call({String name, String? sourceFilePath, String startupFilePath});
}

/// @nodoc
class __$ConfigurationCopyWithImpl<$Res>
    extends _$ConfigurationCopyWithImpl<$Res>
    implements _$ConfigurationCopyWith<$Res> {
  __$ConfigurationCopyWithImpl(
      _Configuration _value, $Res Function(_Configuration) _then)
      : super(_value, (v) => _then(v as _Configuration));

  @override
  _Configuration get _value => super._value as _Configuration;

  @override
  $Res call({
    Object? name = freezed,
    Object? sourceFilePath = freezed,
    Object? startupFilePath = freezed,
  }) {
    return _then(_Configuration(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sourceFilePath: sourceFilePath == freezed
          ? _value.sourceFilePath
          : sourceFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      startupFilePath: startupFilePath == freezed
          ? _value.startupFilePath
          : startupFilePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Configuration implements _Configuration {
  _$_Configuration(
      {required this.name, this.sourceFilePath, required this.startupFilePath});

  @override
  final String name;
  @override
  final String? sourceFilePath;
  @override
  final String startupFilePath;

  @override
  String toString() {
    return 'Configuration(name: $name, sourceFilePath: $sourceFilePath, startupFilePath: $startupFilePath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Configuration &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.sourceFilePath, sourceFilePath) ||
                const DeepCollectionEquality()
                    .equals(other.sourceFilePath, sourceFilePath)) &&
            (identical(other.startupFilePath, startupFilePath) ||
                const DeepCollectionEquality()
                    .equals(other.startupFilePath, startupFilePath)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(sourceFilePath) ^
      const DeepCollectionEquality().hash(startupFilePath);

  @JsonKey(ignore: true)
  @override
  _$ConfigurationCopyWith<_Configuration> get copyWith =>
      __$ConfigurationCopyWithImpl<_Configuration>(this, _$identity);
}

abstract class _Configuration implements Configuration {
  factory _Configuration(
      {required String name,
      String? sourceFilePath,
      required String startupFilePath}) = _$_Configuration;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String? get sourceFilePath => throw _privateConstructorUsedError;
  @override
  String get startupFilePath => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConfigurationCopyWith<_Configuration> get copyWith =>
      throw _privateConstructorUsedError;
}
