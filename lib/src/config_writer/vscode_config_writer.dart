import 'dart:convert';
import 'dart:io';

import 'package:define_env/src/config_writer/config_writer.dart';

/// [ConfigWriter] for VS Code.
///
/// This [ConfigWriter] takes the launch.json file, reads it and retains non dart-define arguments.
/// The new dart-define string generated from the .env file is appended to the retained arguments.
class VscodeConfigWriter extends ConfigWriter {
  /// [projectPath] is the path to VS Code project. It should contain the '.vscode/launch.json' file.
  /// [dartDefineString] is the dart-define string which is to be written to the config
  /// [configName] is the name of an existing configuration in launch.json. A config is not created if it is not found.
  VscodeConfigWriter({
    required String projectPath,
    required String dartDefineString,
    required String? configName,
    String? startupFilePath,
  }) : super(
          projectPath: projectPath,
          dartDefineString: dartDefineString,
          configName: configName,
          startupFilePath: startupFilePath,
        );

  @override
  File getFileToUpdate() => File(projectPath + "/.vscode/launch.json");

  @override
  String writeConfig(String fileContent) {
    /// launch.json usually contains comments, which is valid only in JSON5.
    /// At this point however we cannot preserve these comments.
    fileContent = fileContent.replaceAll(RegExp('.+//.+\n'), "");
    // removes trailing commas which can produce json decode exception 
    fileContent = fileContent.replaceAll(RegExp('/\,(?=\s*?[\}\]])/g'), ""); 

    var configJson = jsonDecode(fileContent) as Map<String, dynamic>;

    var configList =
        new List<Map<String, dynamic>>.from(configJson["configurations"]);

    final dartDefineList = getDartDefineList();

    if (configList.any((config) => config["name"] == configName)) {
      final config =
          configList.firstWhere((config) => config["name"] == configName);

      final updatedConfigWithDartDefine = updateConfig(config, dartDefineList);
      final updatedConfigWithProgram =
          updateProgram(updatedConfigWithDartDefine, startupFilePath);
      configList[
              configList.indexWhere((config) => config['name'] == configName)] =
          updatedConfigWithProgram;
    } else {
      final Map<String, dynamic> config = {
        "name": configName,
        "request": "launch",
        "type": "dart",
        "program": "lib/main.dart",
        "toolArgs": [],
      };

      final updatedConfigWithDartDefine = updateConfig(config, dartDefineList);
      final updatedConfigWithProgram =
          updateProgram(updatedConfigWithDartDefine, startupFilePath);
      configList.add(updatedConfigWithProgram);
    }

    configJson["configurations"] = configList;
    return prettifyJson(configJson);
  }

  /// Update a single VS Code [config] with [dartDefineList].
  Map<String, dynamic> updateConfig(
    Map<String, dynamic> config,
    Iterable<String> dartDefineList,
  ) {
    if (config.containsKey("toolArgs")) {
      config["toolArgs"] = getNonDartDefineArguments(config["toolArgs"])
          .followedBy(dartDefineList)
          .toList();
      return config;
    } else {
      config["toolArgs"] = dartDefineList;
      return config;
    }
  }

  /// Update a single VS Code [config] with [program] property.
  Map<String, dynamic> updateProgram(
    Map<String, dynamic> config,
    String? startupFilePath,
  ) {
    if (config.containsKey("program")) {
      if (startupFilePath != null) {
        config["program"] = "lib/" + startupFilePath;
      }
    } else {
      if (startupFilePath != null) {
        config["program"] = "lib/" + startupFilePath;
      }
    }

    return config;
  }

  /// Pretty Print [json]
  String prettifyJson(dynamic json) {
    var spaces = ' ' * 2;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }

  /// Take [argList] and return only non dart define arguments from the list
  ///
  /// This is useful when you have arguments such as --profile or --release.
  List<dynamic> getNonDartDefineArguments(List<dynamic> argList) {
    bool previousWasDartDefine = false;

    List retainedArgs = [];
    argList.forEach((arg) {
      if (arg == '--dart-define') {
        previousWasDartDefine = true;
        return;
      }

      if (!previousWasDartDefine) {
        retainedArgs.add(arg);
      }

      previousWasDartDefine = false;
    });
    return retainedArgs;
  }

  /// Splits the dart-define string into a list format as required by VS Code.
  List<String> getDartDefineList() {
    return (dartDefineString.split("--dart-define=")..removeAt(0))
        .expand((element) => ["--dart-define", element.trim()])
        .toList();
  }
}
