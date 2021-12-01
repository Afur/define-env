import 'dart:io';

import 'package:define_env/define_env.dart';

abstract class ConfigRemover {
  final String projectPath;
  final String configName;

  ConfigRemover({
    required this.projectPath,
    required this.configName,
  });

  File getFileToUpdate();

  String removeFrom(String fileContent);

  void call() {
    <File>[]
      ..add(getFileToUpdate())
      ..forEach(
        (file) {
          file.writeAsStringSync(
            removeFrom(
              file.readAsStringSync(),
            ),
          );
        },
      );
  }
}
