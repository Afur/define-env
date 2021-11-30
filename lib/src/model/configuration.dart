import 'package:define_env/src/model/platform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'configuration.freezed.dart';

@freezed
class Configuration with _$Configuration {
  factory Configuration({
    required String name,
    required Platform platform,
    String? sourceFilePath,
    required String startupFilePath,
  }) = _Configuration;
}