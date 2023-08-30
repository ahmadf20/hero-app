import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData appThemeData = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.blue.shade500,
    splashColor: Colors.blue.shade100,
    highlightColor: Colors.blue.shade50,
    fontFamily: 'ProductSans',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    canvasColor: Colors.white,
    dividerColor: Colors.grey.shade200,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.all(Colors.blue.shade200),
      trackColor: MaterialStateProperty.all(Colors.grey.shade200),
      radius: const Radius.circular(10),
    ),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   selectedItemColor: Colors.blue.shade500,
    //   unselectedItemColor: Colors.grey.shade500,
    // ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.grey.shade500,
      ),
      bodyMedium: TextStyle(
        color: Colors.grey.shade800,
      ),
    ),
  );

  static SystemUiOverlayStyle mySystemUIOverlayStyleDark =
      SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: Colors.white, // navigation bar color
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent, // status bar
    systemStatusBarContrastEnforced: true,
    // systemNavigationBarDividerColor: Colors.white,
    // statusBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle mySystemUIOverlayStyleLight =
      SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: Colors.white, // navigation bar color
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent, // status bar
    systemStatusBarContrastEnforced: true,
    // systemNavigationBarDividerColor: Colors.white,
    // statusBarIconBrightness: Brightness.dark,
  );
}
