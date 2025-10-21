import 'package:logger/logger.dart';

/// Global logger configured to show only error-level logs.
final Logger appLogger = Logger(
  level: Level.error, // 👈 Only show error logs
  printer: PrettyPrinter(
    methodCount: 2, // number of method calls to show
    errorMethodCount: 5, // number of method calls if stacktrace is provided
    lineLength: 80,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // 👈 replaces printTime
  ),
);
