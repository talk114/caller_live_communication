import 'dart:io';
import 'package:flutter/material.dart';
import 'package:caller_telephony/Core/UserPermission.dart';
import 'package:caller_telephony/Utilities/outputHelper.dart';
import 'package:flutter_webrtc/webrtc.dart';

import 'package:toast/toast.dart';
import 'package:caller_telephony/Server/Signaling.dart';

void main() {
  runApp(Telephony());
}

class Telephony extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '電話軟件榜样',
      debugShowCheckedModeBanner: false,
      home: TelephonyPage(title: '電話軟件榜样'),
    );
  }
}

class TelephonyPage extends StatefulWidget {
  TelephonyPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TelephonyPageState createState() {
    return _TelephonyPageState();
  }
}

class _TelephonyPageState extends State<TelephonyPage> {
  /*  變量分配 */

  // 網絡套接字網址
  String url;

  // 信號類別
  RTCSignaling _signaling;

  // 本地顯示名稱
  String displayname =
      '${Platform.localeName.substring(0, 2)} + (${Platform.operatingSystem})';

  // 房間內的peer對象
  List<dynamic> _peers;

  var _selfId;

  // 本地媒體對象
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  // 對端媒體對象
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  // 是否處與通話狀態
  bool _inCalling = false;

  /*  邏輯組件 */

  @override
  void initState() {
    super.initState();

    PrintHelper().lprint('初始化軟件...', false);

    requestUserPermission();

    intiRendereres();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 請求用戶許可
  void requestUserPermission() {
    if (Platform.isAndroid) {
      OperatingSystemPermission().requestAndroidUserPermission();
    } else if (Platform.isIOS) {
      OperatingSystemPermission().requestIOSUserPermission();
    } else {
      PrintHelper().lprint('該軟件尚不支持該操作系統', false);
    }
  }

  // 啟動媒體渲染器
  void intiRendereres() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  // 呼叫對方
  void connect() async {
    if(_signaling == null) {
      // _signaling = RTCSignaling();
     
    }
  }

  void _switchCamera () {
    
  }

  /* 用戶界面組件*/

  Widget buildrow(context, peer) {
    return ListBody(
      children: <Widget>[
        ListTile(
          title: Text(peer),
          trailing: SizedBox(
            width: 100,
            child: IconButton(
              onPressed: connect,
              icon: Icon(
                Icons.videocam,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.lightGreen[500],
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            dispose();
            return exit(0);
          },
          child: Icon(
            Icons.close,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              PrintHelper().lprint(' 此软件由 John Melody Me 创作', false);
              Toast.show(" 此软件由 John Melody Me 创作", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
            tooltip: '關於軟件開發人員',
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: 80,
        itemBuilder: (context, i) {
          return buildrow(context, '測驗');
        },
      ),
    );
  }
}
