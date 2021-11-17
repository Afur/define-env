import 'dart:io';

import 'package:define_env/src/config_writer/config_writer.dart';
import 'package:xml/xml.dart';

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
    String? startupFilePath,
  }) : super(
          projectPath: projectPath,
          dartDefineString: dartDefineString,
          configName: configName,
          startupFilePath: startupFilePath,
        );

  @override
  List<File> getMandatoryFilesToUpdate() => [];

  @override
  List<File> getOptionalFilesToUpdate() {
    var workspaceFilePath = projectPath + "/.idea/workspace.xml";
    return [File(workspaceFilePath)];
  }

  @override
  String writeConfig(String configXmlString) {
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

    updateConfigurations(configurations, configName);

    // Update runManager
    runManager.children.clear();
    runManager.children.addAll(configurations);

    return configXml.toXmlString(pretty: true);
  }

  void updateConfigurations(
      List<XmlElement> configurations, String? configName) {
    if (configName == null) return;

    final configurationsToUpdate = configurations
        .where(
          (element) => element.attributes.any(
            (it) => it.name == XmlName("name") && it.value.contains(configName),
          ),
        )
        .toList();

    if (configurationsToUpdate.isNotEmpty) {
      configurationsToUpdate.forEach(
        (configuration) {
          final index = configurations.indexOf(configuration);
          updateConfiguration(configuration);
          configurations[index] = configuration;
        },
      );
    } else {
      final configuration = _createEmptyConfiguration();
      updateConfiguration(configuration);
      configurations.add(configuration);
    }
  }

  void updateConfiguration(XmlElement configuration) {
    final configurationElements = configuration.childElements.toList();
    updateConfigurationElements(configurationElements);

    // Update configuration
    configuration.children.clear();
    configuration.children.addAll(configurationElements);
  }

  void updateConfigurationElements(List<XmlElement> configurationElements) {
    final existingOptionsIndex = configurationElements.indexWhere(
      (element) => element.attributes.any(
        (it) => it.name == XmlName("name") && it.value == "additionalArgs",
      ),
    );

    if (existingOptionsIndex != -1) {
      // There's already an option element with additionalArgs attribute so we want to update it
      final options = configurationElements[existingOptionsIndex];
      final updatedOptions = updateElement(options);
      configurationElements[existingOptionsIndex] = updatedOptions;
    } else {
      // We need to create new element for options with additionalArgs
      final options = _createEmptyOptions();

      final updatedOptions = updateElement(options);
      configurationElements.add(updatedOptions);
    }
  }

  /// Creates new Configuration [configuration] for new [configName]
  XmlElement _createEmptyConfiguration() => XmlElement(
        XmlName("configuration"),
        [
          XmlAttribute(XmlName("name"), configName ?? ""),
          XmlAttribute(XmlName("type"), "FlutterRunConfigurationType"),
          XmlAttribute(XmlName("factoryName"), "Flutter"),
        ],
        [
          XmlElement(
            XmlName("option"),
            [
              XmlAttribute(XmlName("name"), "filePath"),
              XmlAttribute(
                  XmlName("value"),
                  startupFilePath != null
                      ? "\$PROJECT_DIR\$/lib/" + startupFilePath!
                      : "\$PROJECT_DIR\$/lib/main.dart"),
              XmlAttribute(XmlName("factoryName"), "Flutter"),
            ],
            [],
            true,
          ),
          XmlElement(
            XmlName("method"),
            [
              XmlAttribute(XmlName("v"), "2"),
            ],
            [],
            true,
          ),
          XmlElement(
            XmlName("option"),
            [
              XmlAttribute(XmlName("name"), "additionalArgs"),
              XmlAttribute(XmlName("value"), ""),
            ],
            [],
            true,
          )
        ],
        true,
      );

  /// Creates new Option [option] for new [additionalArgs]
  XmlElement _createEmptyOptions() => XmlElement(
        XmlName("option"),
      )
        ..setAttribute(
          "name",
          "additionalArgs",
        )
        ..setAttribute(
          "value",
          "",
        );

  /// Update the Configuration [option] with new dart-define while preserving old arguments.
  XmlElement updateElement(XmlElement option) {
    var oldArguments = option.getAttribute('value')!;
    var retainedArgs = getRetainedArgs(oldArguments);

    option.setAttribute(
      'value',

      /// We are trimming here because retained arguments can be empty
      /// and because of that our dart-defines will not be parsed properly
      /// because of the extra spaces
      (retainedArgs + " " + dartDefineString).trim(),
    );

    return option.copy();
  }

  /// Remove all dart-defines from [oldArguments] and return whatever is remaining.
  String getRetainedArgs(String oldArguments) {
    var retainedArgs = oldArguments
        .replaceAll("&quot;", "\"")
        .replaceAll(RegExp('--dart-define=[^ "]+(["\'])([^"\'])+(["\'])'), '')
        .replaceAll(RegExp('--dart-define=[^ "]+'), '')
        .trim();
    return retainedArgs;
  }
}
