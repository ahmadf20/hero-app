import 'dart:convert';

import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    printTime: true,
  ),
);

void loggerJson(Object res) {
  logger.t(jsonDecode(res.toString()));
}
