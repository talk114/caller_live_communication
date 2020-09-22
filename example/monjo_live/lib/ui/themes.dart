import 'package:flutter/material.dart';

class Themes {
  Themes._();
  BuildContext context;

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
    actions: <Widget>[
      IconButton(
        onPressed: () {
          showAlertDialog(BuildContext context) {
            Widget okButton = FlatButton(
              child: Text('知道了'),
              onPressed: () {
                /// nothing
              },
            );

            AlertDialog alert = AlertDialog(
              title: Text('媒体信令平台'),
              content: Text('这个软件是由 John Melody Me创建的'),
              actions: [
                okButton,
              ],
            );

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          }
        },
        icon: Icon(
          Icons.info,
          color: Colors.white,
        ),
      ),
    ],
  );
}
