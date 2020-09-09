import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'util/logger.dart';
import 'util/permission.dart';
import 'package:flutter/material.dart';
import 'ui/themes.dart';
import 'util/logger.dart';

void main() {
  runApp(MonjoLivePrototype());
}

class MonjoLivePrototype extends StatefulWidget {
  @override
  _MonjoLivePrototypeState createState() => _MonjoLivePrototypeState();
}

class _MonjoLivePrototypeState extends State<MonjoLivePrototype> {
  SharedPreferences _preferences;
  String _server = '';

  @override
  void initState() {
    super.initState();
    logger("Widget Started");

    /// Request Permission
    if (Platform.isAndroid) {
      AndroidOperatingSystemPermission();
    } else if (Platform.isIOS) {
      IOSOperatingSystemPermission();
    }

    _initData();
  }

  _initData() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _server = _preferences.getString('server') ?? 'demo.cloudwebrtc.com';
      logger("connected To $_server");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: Themes.defaultAppBar,
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Text('Test'),
          ],
        ),
      ),
    );
  }
}
