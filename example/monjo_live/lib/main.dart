import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:monjo_live/ui/themes.dart';
import 'package:monjo_live/util/logger.dart';
import 'core/permission.dart';

void main() {
  runApp(
    MaterialApp(
      title: '媒体信令平台',
      darkTheme: Themes.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: CallerApp(),
    ),
  );
}

class CallerApp extends StatefulWidget {
  CallerApp({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _CallerAppState createState() {
    return _CallerAppState();
  }
}

class _CallerAppState extends State<CallerApp> {
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    initRenderers();
    _getUserMedia();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream mediaStream = await navigator.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = mediaStream;
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  requestPermission() {
    if (Platform.isAndroid) {
      AndroidOperatingSystemPermission().requestAndroidUserPermission();
    } else if (Platform.isIOS) {
      IOSOperatingSystemPermission().requestIOSUserPermission();
    } else {
      logger('没有这样的操作系统');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Themes.defaultAppBar,
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              right: 0.0,
              left: 0.0,
              bottom: 0.0,
              child: Container(
                child: RTCVideoView(_localRenderer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
