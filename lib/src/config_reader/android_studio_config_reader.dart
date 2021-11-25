import 'dart:io';

import 'package:define_env/src/config_reader/config_reader.dart';
import 'package:define_env/src/config_writer/config_writer.dart';
import 'package:define_env/src/model/configuration.dart';
import 'package:xml/xml.dart';
import 'package:collection/collection.dart';

class AndroidStudioConfigReader extends ConfigReader {
  AndroidStudioConfigReader({
    required String projectPath,
  }) : super(
          projectPath: projectPath,
        );

  @override
  List<Configuration> loadConfigurations() {
    final workspaceFilePath = projectPath + "/.idea/workspace.xml";
    final workspaceFile = File(workspaceFilePath);

    final configXmlString = workspaceFile.readAsStringSync();

    final configXml = XmlDocument.parse(configXmlString);

    final project = configXml.childElements.toList().first;

    final elements = project.childElements.toList();
    final runManagerIndex = project.childElements.toList().indexWhere(
          (element) => element.attributes.any(
            (it) => it.value == "RunManager",
          ),
        );

    final runManager = elements[runManagerIndex];
    final configurationsElements = runManager.childElements
        .where((element) => element.name == XmlName("configuration"))
        .toList();

    return configurationsElements.map((configurationElement) {
      final configurationName = configurationElement.attributes
          .firstWhere(
            (it) => it.name == XmlName("name"),
          )
          .value;

      var optionWithFilePath = configurationElement.childElements.firstWhere(
        (element) => element.attributes.any(
          (attribute) => attribute.value == "filePath",
        ),
      );

      final filePath = optionWithFilePath.attributes
          .firstWhere((attribute) => attribute.value == "filePath")
          .value;

      final startupFilePath = filePath.split("lib/").last;

      return Configuration(
        name: configurationName,
        startupFilePath: startupFilePath,
      );
    }).toList();
  }
}
