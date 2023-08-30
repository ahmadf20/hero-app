import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../core/utils/logger.dart';
import '../../core/values/error_message.dart';
import 'loading_indicator.widget.dart';

class MyBotToast {
  MyBotToast._();

  static void text(Object text) {
    logger.d('MyBotToast.text: $text');
    BotToast.showText(
      text: text.toString(),
      textStyle: const TextStyle(
        fontSize: 14,
      ),
      duration: const Duration(seconds: 3),
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      clickClose: true,
      contentColor: Colors.grey[200]!,
      contentPadding: const EdgeInsets.fromLTRB(20, 12.5, 20, 12.5),
    );
  }

  static void error([Object? val]) {
    logger.d('MyBotToast.text: $val');
    text(val ?? ErrorMessage.general);
  }

  static void loading() {
    logger.d('MyBotToast.loading');
    BotToast.showCustomLoading(
      toastBuilder: (c) => MyLoadingIndicator.circular(color: Colors.white),
    );
  }

  static void closeLoading() {
    BotToast.closeAllLoading();
  }
}
