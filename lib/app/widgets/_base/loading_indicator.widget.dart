import 'package:flutter/material.dart';

import '../../core/themes/app.theme.dart';

class MyLoadingIndicator {
  MyLoadingIndicator._();

  static Widget circular({
    Color? color,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    double? strokeWidth,
  }) {
    return Container(
      alignment: Alignment.center,
      margin: margin,
      width: width,
      height: height,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppTheme.appThemeData.primaryColor,
        ),
        strokeWidth: strokeWidth ?? 3,
      ),
    );
  }
}
