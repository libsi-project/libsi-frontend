import 'package:talker/talker.dart';

final Talker logger = Talker();

setupLogger({LogLevel? level}) {
  logger.settings = TalkerSettings(enabled: level != null);
  // EasyLocalization.logger.printer = (object, {level, name, stackTrace}) {
  //   logger.log(
  //     object,
  //     logLevel: level?.name.toEnumType(LogLevel.values) ?? LogLevel.debug,
  //     stackTrace: stackTrace,
  //   );
  // };
}
