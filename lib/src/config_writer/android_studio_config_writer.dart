import 'dart:io';

import 'package:define_env/src/config_writer/config_writer.dart';
import 'package:xml_parser/xml_parser.dart';

/// [ConfigWriter] for Android Studio and Intellij IDEs.
///
/// This [ConfigWriter] reads all xml files containing Run configuration and retains non dart-define arguments.
/// The new dart-define string generated from the .env file is appended to the retained arguments.
class AndroidStudioConfigWriter extends ConfigWriter {
  /// [projectPath] is the path to Android Studio project.
  /// It should contain the '.idea/workspace.xml' file or '.run/*.xml' files
  /// [dartDefineString] is the dart-define string which is to be written to the config
  /// [configName] is the name of an existing configuration in launch.json. A config is not created if it is not found.
  AndroidStudioConfigWriter({
    required String projectPath,
    required String dartDefineString,
    required String? configName,
  }) : super(
          projectPath: projectPath,
          dartDefineString: dartDefineString,
          configName: configName,
        );

  @override
  List<File> getMandatoryFilesToUpdate() => [];

  @override
  List<File> getOptionalFilesToUpdate() {
    var workspaceFilePath = projectPath + "/.idea/workspace.xml";

    /*var runDirectoryPath = projectPath + "/.run";
    var runDirectory = Directory(runDirectoryPath);
    var filesToUpdate = runDirectory
        .listSync()
        .where((element) => element.uri.toString().endsWith('.run.xml'))
        .map((element) => File(element.uri.toString()))
        .toList();

    filesToUpdate.add(File(workspaceFilePath));*/
    return [File(workspaceFilePath)];
  }

  @override
  String writeConfig(String configXmlString) {
    var xmlDocument = XmlDocument.from(configXmlString);
    final project = xmlDocument?.getChildWhere(name: "project");

    final runManager = project?.getChildWhere(
        name: "component",
        attributes: [XmlAttribute("name", "RunManager")],
        matchAllAttributes: true);
    final configurations = runManager?.getChildrenWhere(name: "configuration") ?? [];

    final configurationIndex = configurations.indexWhere(
      (element) => element.attributes!.contains(
        XmlAttribute("name", "main.dart" ?? ""),
      ),
    );

    if(configurationIndex == -1) {
      //configurations.add(configurations.first.copyWith(a));
    }

    return "";
    /*var flutterConfigElements = configXml
        .findAllElements('configuration')
        .where(isXmlElementFlutterConfig)
        .toList();

    if (configName != null &&
        flutterConfigElements.contains(isXmlElementSameAsConfig)) {
      flutterConfigElements =
          flutterConfigElements.where(isXmlElementSameAsConfig).toList();
    }

    flutterConfigElements.forEach((element) {
      final options = element
          .findAllElements('option')
          .where(elementHasArgs)
          .toList();

      if (options.isEmpty) {
        options.add(
          XmlElement(
            XmlName("option"),
          )
            ..setAttribute(
              "name",
              "additionalArgs",
            )
            ..setAttribute(
              "value",
              "",
            ),
        );
      }

      options.forEach(updateElement);
    });


    return configXml.toXmlString();*/
  }

  /*bool isXmlElementFlutterConfig(XmlElement element) =>
      element.getAttribute('type') == 'FlutterRunConfigurationType';

  bool isXmlElementSameAsConfig(XmlElement element) =>
      element.getAttribute('name') == configName;

  void updateAndroidStudioConfiguration(XmlElement configurationNode) {
    final options = configurationNode
        .findAllElements('option')
        .where(elementHasArgs)
        .toList();

    if (options.isEmpty) {
      options.add(
        XmlElement(
          XmlName("option"),
        )
          ..setAttribute(
            "name",
            "additionalArgs",
          )
          ..setAttribute(
            "value",
            "",
          ),
      );
    }

    options.forEach(updateElement);
  }

  /// Checks if [element] has 'additionalArgs'. We should ideally check for 'attachArgs' too I suppose.
  bool elementHasArgs(XmlElement element) =>
      element.getAttribute('name') == 'additionalArgs';

  /// Update the Configuration [option] with new dart-define while preserving old arguments.
  void updateElement(XmlElement option) {
    var oldArguments = option.getAttribute('value')!;
    var retainedArgs = getRetainedArgs(oldArguments);

    option.setAttribute(
      'value',

      /// We are trimming here because retained arguments can be empty
      /// and because of that our dart-defines will not be parsed properly
      /// because of the extra spaces
      (retainedArgs + " " + dartDefineString).trim(),
    );
  }*/

  /// Remove all dart-defines from [oldArguments] and return whatever is remaining.
  String getRetainedArgs(String oldArguments) {
    var retainedArgs = oldArguments
        .replaceAll("&quot;", "\"")
        .replaceAll(RegExp('--dart-define=[^ "]+(["\'])([^"\'])+(["\'])'), '')
        .replaceAll(RegExp('--dart-define=[^ "]+'), '')
        .replaceAll(RegExp('\s+'), ' ')
        .trim();
    return retainedArgs;
  }
}
