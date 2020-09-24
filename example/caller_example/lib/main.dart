import 'dart:io';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:toast/toast.dart';
import 'package:caller_example/Core/UserPermission.dart';
import 'package:caller_example/Helper/outputHelper.dart';
import 'package:flutter/material.dart';
import 'package:caller_example/Server/Signalling.dart';

void main() {
  runApp(CallerExample());
}

class CallerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '音素軟件',
      home: CallerExamplePage(title: '音素軟件'),
    );
  }
}

class CallerExamplePage extends StatefulWidget {
  CallerExamplePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CallerExamplePageState createState() {
    return _CallerExamplePageState();
  }
}

class _CallerExamplePageState extends State<CallerExamplePage> {
  // DECLARTION
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  CallerSignaling signaling;

  String server = '192.168.1.117:8086';

  var _selfId;

  List<dynamic> _peers;

  bool _inCalling = false;
  // LOGIC COMPONENT

  @override
  void initState() {
    super.initState();

    // 请求用户权限
    requestUserPermission();

    PrintHelper().lprint('启动 Widget.....', false);

    /// 渲染器配置
    initRenderers();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  requestUserPermission() {
    if (Platform.isAndroid) {
      AndroidOperatingSystemPermission().requestAndroidUserPermission();
    } else if (Platform.isIOS) {
      IOSOperatingSystemPermission().requestIOSUserPermission();
    } else {
      PrintHelper().lprint('不支持这 OS ', true);
    }
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void connect() async {
    if (signaling == null) {
      signaling = CallerSignaling(server)..connect();

      signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            this.setState(() {
              _inCalling = true;
            });
            break;

          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
            break;

          case SignalingState.CallStateRinging:
          case SignalingState.CallStateInvite:
          case SignalingState.CallStateConnected:
          case SignalingState.ConnectionOpen:
          case SignalingState.ConnectionClosed:
          case SignalingState.ConnectionError:
            break;
        }
      };

      signaling.onPeersUpdate = ((event) {
        this.setState(() {
          _selfId = event['self'];
          _peers = event['peers'];
        });
      });

      signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
      });

      signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

  invitePeer(context, peerId, usescreen) async {
    if (signaling != null && peerId != _selfId) {
      signaling.invite(peerId, 'video', usescreen);
    } else {
      PrintHelper().warning('邀請同伴失敗', 1);
    }
  }

  hangUp() {
    if (signaling != null) {
      signaling.bye();
    } else {
      PrintHelper().warning('掛斷失敗', 1);
    }
  }

  switchCamera() {
    signaling.switchCamera();
  }

  muteMic() {
    // TODO 增加麥克風靜音功能
  }

  // UI COMPONENT
  buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    return ListBody(
      children: <Widget>[
        ListTile(
          title: Text((() {
            if (self) {
              return peer['name'] + '[Your self]';
            } else {
              return peer['name'] + '[' + peer['user_agent'] + ']';
            }
          }())),
          onTap: null,
          trailing: SizedBox(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: () {
                    return invitePeer(context, peer['id'], false);
                  },
                  tooltip: '視頻通話',
                ),
                IconButton(
                  icon: const Icon(Icons.screen_share),
                  onPressed: () {
                    return invitePeer(context, peer['id'], true);
                  },
                  tooltip: '屏幕共享',
                )
              ],
            ),
          ),
          subtitle: Text('id: ' + peer['id']),
        ),
        Divider(
          color: Colors.pinkAccent,
        ),
      ],
    );
  }

  OrientationBuilder callerui() {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: RTCVideoView(_remoteRenderer),
                decoration: BoxDecoration(color: Colors.black45),
              ),
            ),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height: orientation == Orientation.portrait ? 120.0 : 90.0,
                child: RTCVideoView(_localRenderer),
                decoration: BoxDecoration(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    });
  }

  SizedBox bottomfloatingbutton() {
    return SizedBox(
      width: 200.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.switch_camera),
            onPressed: switchCamera,
          ),
          FloatingActionButton(
            onPressed: hangUp,
            tooltip: 'Hangup',
            child: Icon(Icons.call_end),
            backgroundColor: Colors.pink,
          ),
          FloatingActionButton(
            child: const Icon(Icons.mic_off),
            onPressed: muteMic,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            dispose();
            return exit(0);
          },
          child: Icon(
            Icons.close,
          ),
        ),
        title: Text(widget.title),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        actions: [
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (() {
        if (_inCalling) {
          return bottomfloatingbutton();
        } else {
          return null;
        }
      }()),
      body: (() {
        if (_inCalling) {
          return callerui();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemCount: (() {
              if (_peers != null) {
                return _peers.length;
              } else {
                return 0;
              }
            }()),
            itemBuilder: (context, i) {
              return buildRow(context, _peers[i]);
            },
          );
        }
      }()),
    );
  }
}
