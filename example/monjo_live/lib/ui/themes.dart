import 'package:flutter/material.dart';

class Themes {
  Themes._();

  static ThemeData defaultTheme = ThemeData(
    backgroundColor: Colors.black87,
  );

  static AppBar defaultAppBar = AppBar(
    title: const Text(
      '媒体信令平台',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.green,
    brightness: Brightness.light,
  );
}
