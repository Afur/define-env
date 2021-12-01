import 'dart:io';

import 'package:define_env/src/config_remover/config_remover.dart';
import 'package:define_env/src/model/platform.dart';
import 'package:xml/xml.dart';

class AndroidStudioConfigRemover extends ConfigRemover {
  AndroidStudioConfigRemover({
    required String projectPath,
    required String configName,
  }) : super(
          projectPath: projectPath,
          configName: configName,
        );

  @override
  File getFileToUpdate() => File(projectPath + "/.idea/workspace.xml");

  @override
  String removeFrom(String configXmlString) {
    final configXml = XmlDocument.parse(configXmlString);

    final project = configXml.childElements.toList().first;

    final elements = project.childElements.toList();
    final runManagerIndex = project.childElements.toList().indexWhere(
          (element) => element.attributes.any(
            (it) => it.value == "RunManager",
          ),
        );

    final runManager = elements[runManagerIndex];
    final configurations = runManager.childElements
        .where((element) => element.name == XmlName("configuration"))
        .toList();

    configurations.removeWhere(
      (element) => element.attributes.any(
        (it) => it.name == XmlName("name") && it.value.contains(configName),
      ),
    );

    // Update runManager
    runManager.children.clear();
    runManager.children.addAll(configurations);

    return configXml.toXmlString(pretty: true);
  }
}
