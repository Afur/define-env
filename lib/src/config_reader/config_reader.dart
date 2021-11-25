import 'package:define_env/src/model/configuration.dart';

abstract class ConfigReader {
  final String projectPath;

  ConfigReader({
    required this.projectPath,
  });

  List<Configuration> loadConfigurations();
}
