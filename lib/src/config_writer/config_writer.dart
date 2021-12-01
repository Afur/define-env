import 'dart:io';

abstract class ConfigWriter {
  final String projectPath;
  final String dartDefineString;
  final String? configName;
  final String? startupFilePath;

  ConfigWriter({
    required this.projectPath,
    required this.dartDefineString,
    required this.configName,
    this.startupFilePath,
  });

  File getFileToUpdate();

  String writeConfig(String fileContent);

  void call() {
    <File>[]
      ..add(getFileToUpdate())
      ..forEach((file) {
        file.writeAsStringSync(
          writeConfig(
            file.readAsStringSync(),
          ),
        );
      });
  }
}
