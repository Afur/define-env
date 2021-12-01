import 'dart:convert';
import 'dart:io';

import 'package:define_env/src/config_remover/config_remover.dart';
import 'package:define_env/src/model/platform.dart';
import 'package:xml/xml.dart';

class VscodeStudioConfigRemover extends ConfigRemover {
  VscodeStudioConfigRemover({
    required String projectPath,
    required String configName,
  }) : super(
    projectPath: projectPath,
    configName: configName,
  );

  @override
  File getFileToUpdate() => File(projectPath + "/.vscode/launch.json");

  @override
  String removeFrom(String fileContent) {
    fileContent = fileContent.replaceAll(RegExp('.+//.+\n'), "");

    var configJson = jsonDecode(fileContent) as Map<String, dynamic>;

    var configList =
    new List<Map<String, dynamic>>.from(configJson["configurations"]);

    configList.removeWhere((config) => config["name"] == configName);
    configJson["configurations"] = configList;

    return prettifyJson(configJson);
  }

  String prettifyJson(dynamic json) {
    var spaces = ' ' * 2;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }
}
