import 'dart:convert';
import 'dart:io';

import 'package:define_env/src/config_reader/config_reader.dart';
import 'package:define_env/src/model/configuration.dart';

class VscodeConfigConfigReader extends ConfigReader {
  VscodeConfigConfigReader({
    required String projectPath,
  }) : super(
          projectPath: projectPath,
        );

  @override
  List<Configuration> loadConfigurations() {
    final configFile = File(projectPath + "/.vscode/launch.json");

    var fileContent = configFile.readAsStringSync();
    fileContent = fileContent.replaceAll(RegExp('.+//.+\n'), "");

    var configJson = jsonDecode(fileContent) as Map<String, dynamic>;

    var configurations =
        new List<Map<String, dynamic>>.from(configJson["configurations"]);

    return configurations.map((configuration) {
      final name = configuration["name"];
      final String filePath = configuration["program"] ?? "";
      final startupFilePath = filePath.replaceAll("lib/", "");

      return Configuration(
        name: name,
        startupFilePath: startupFilePath,
      );
    }).toList();
  }
}
