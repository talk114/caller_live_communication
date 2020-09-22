import 'dart:io';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Themes {
  Themes._();
  static BuildContext context;

  static ThemeData defaultTheme = ThemeData(
    backgroundColor: Colors.black87,
  );

  static AppBar defaultAppBar = AppBar(
   leading: GestureDetector(
          onTap: () {
            return exit(0);
          },
          child: Icon(
            Icons.close,
          ),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          '媒体信令平台',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        brightness: Brightness.light,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Toast.show(" 此软件由 John Melody Me 创作", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
  );
}
