import 'package:flutter/material.dart';

class Themes {
  Themes._();

  static ThemeData defaultTheme = ThemeData(
    backgroundColor: Colors.black87,
  );

  static AppBar defaultAppBar = AppBar(
    title: const Text(
      'Monjo Live',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.green,
    brightness: Brightness.light,
  );
}
