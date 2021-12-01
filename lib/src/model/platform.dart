import 'package:define_env/define_env.dart';
import 'package:define_env/src/config_remover/android_studio_config_remover.dart';
import 'package:define_env/src/config_remover/config_remover.dart';
import 'package:define_env/src/config_remover/vscode_config_remover.dart';

import 'package:define_env/src/config_writer/config_writer.dart';

enum Platform {
  androidStudio,
  vsCode,
}

extension PlatformExt on Platform {
  ConfigReader configReader({
    required String projectPath,
  }) {
    switch (this) {
      case Platform.androidStudio:
        return AndroidStudioConfigReader(
          projectPath: projectPath,
        );
      case Platform.vsCode:
        return VscodeConfigReader(
          projectPath: projectPath,
        );
    }
  }

  ConfigWriter configWriter({
    required String projectPath,
    required String dartDefineString,
    required String? configName,
    String? startupFilePath,
  }) {
    switch (this) {
      case Platform.androidStudio:
        return AndroidStudioConfigWriter(
          projectPath: projectPath,
          dartDefineString: dartDefineString,
          configName: configName,
          startupFilePath: startupFilePath,
        );
      case Platform.vsCode:
        return VscodeConfigWriter(
          projectPath: projectPath,
          dartDefineString: dartDefineString,
          configName: configName,
          startupFilePath: startupFilePath,
        );
    }
  }

  ConfigRemover configRemover({
    required String projectPath,
    required String configName,
  }) {
    switch (this) {
      case Platform.androidStudio:
        return AndroidStudioConfigRemover(
          projectPath: projectPath,
          configName: configName,
        );
      case Platform.vsCode:
        return VscodeStudioConfigRemover(
          projectPath: projectPath,
          configName: configName,
        );
    }
  }
}