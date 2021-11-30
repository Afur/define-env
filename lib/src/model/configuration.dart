import 'package:freezed_annotation/freezed_annotation.dart';

part 'configuration.freezed.dart';

@freezed
class Configuration with _$Configuration {
  factory Configuration({
    required String name,
    String? sourceFilePath,
    required String startupFilePath,
  }) = _Configuration;
}