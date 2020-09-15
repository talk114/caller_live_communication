import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:monjo_live/ui/themes.dart';
import 'package:monjo_live/network/signalling.dart';
import 'package:monjo_live/util/logger.dart';
import 'package:monjo_live/util/permission.dart';

void main() {
  // TODO change This John
  runApp(CallerWidget(ipAddress: '192.168.1.127'));
}

// ignore: must_be_immutable
class CallerWidget extends StatefulWidget {
  static String tag = 'Caller';
  String ipAddress;

  CallerWidget({Key key, @required this.ipAddress}) : super(key: key);

  @override
  _CallerWidgetState createState() => _CallerWidgetState(server: ipAddress);
}

class _CallerWidgetState extends State<CallerWidget> {
  Signaling _signaling;
  var _individualSecretIndentity;
  bool _isCalling = false;
  List<dynamic> _peersSecretIdentity;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String server;
  _CallerWidgetState({Key key, @required this.server});

  @override
  initState() {
    super.initState();

    // / Request Permission
    if (Platform.isAndroid) {
      AndroidOperatingSystemPermission();
    } else if (Platform.isIOS) {
      IOSOperatingSystemPermission();
    }

    // report to console
    logger('Caller Started');

    // Start Renderer
    startRenderers();
  }

  startRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: Themes.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              exit(0);
            },
            child: Icon(
              Icons.close,
            ),
          ),
          backgroundColor: Colors.green,
          brightness: Brightness.light,
          title: const Text('Voip Caller'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.phone),
              onPressed: () {
                /// something Something
              },
              tooltip: 'Something Something',
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _isCalling
            ? SizedBox(
                width: 200.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      child: const Icon(Icons.switch_camera),
                      onPressed: _switchCamera,
                    ),
                    FloatingActionButton(
                      onPressed: _hangUp,
                      tooltip: 'Hangup',
                      child: Icon(Icons.call_end),
                      backgroundColor: Colors.pink,
                    ),
                    FloatingActionButton(
                      child: const Icon(Icons.mic_off),
                      onPressed: _muteMic,
                    ),
                  ],
                ),
              )
            : null,
        body: _isCalling
            ? OrientationBuilder(
                builder: (context, orientation) {
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
                            decoration: BoxDecoration(color: Colors.black54),
                          ),
                        ),
                        Positioned(
                          left: 20.0,
                          top: 20.0,
                          child: Container(
                            width: orientation == Orientation.portrait
                                ? 90.0
                                : 120.0,
                            height: orientation == Orientation.portrait
                                ? 120.0
                                : 90.0,
                            child: RTCVideoView(_localRenderer),
                            decoration: BoxDecoration(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemCount: (_peersSecretIdentity != null
                    ? _peersSecretIdentity.length
                    : 0),
                itemBuilder: (context, i) {
                  return _buildRow(context, _peersSecretIdentity[i]);
                },
              ),
      ),
    );
  }

  void _connect() async {
    if (_signaling == null) {
      _signaling = Signaling(server)..connect();

      _signaling.onStateChange = (SignalingState signalingState) {
        switch (signalingState) {
          case SignalingState.CallStateNew:
            this.setState(() {
              _isCalling = true;
              logger("SignalingState.CallStateNew: _isCalling = true;");
            });
            break;

          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _isCalling = false;
              logger("SignalingState.CallStateBye: _isCalling = false;");
            });
            break;

          case SignalingState.CallStateInvite:

          case SignalingState.CallStateConnected:

          case SignalingState.CallStateRinging:

          case SignalingState.ConnectionClosed:

          case SignalingState.ConnectionError:

          case SignalingState.ConnectionOpen:
            break;
        }
      };

      _signaling.onPeersUpdate = ((event) {
        this.setState(() {
          _individualSecretIndentity = event['self'];
          _peersSecretIdentity = event['peers'];
        });
      });

      _signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      _signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
      });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

  _invitePeople(context, peerId, usescreen) async {
    if (_signaling != null && peerId != _individualSecretIndentity) {
      _signaling.invite(peerId, 'video', usescreen);
    }
  }

  _hangUp() {
    if (_signaling != null) {
      _signaling.bye();
    }
  }

  _switchCamera() {
    _signaling.switchCamera();
  }

  _muteMic() {
    /// implement this John
  }

  _buildRow(context, peer) {
    var self = (peer['id'] == _individualSecretIndentity);
    return ListBody(
      children: <Widget>[
        ListTile(
          title: Text(self
              ? peer['name'] + '[Your self]'
              : peer['name'] + '[' + peer['user_agent'] + ']'),
          onTap: () {
            logger("Testing");
          },
          trailing: SizedBox(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: () {
                    return _invitePeople(
                      context,
                      peer['id'],
                      false,
                    );
                  },
                  tooltip: 'Video calling',
                ),
                IconButton(
                  icon: const Icon(Icons.screen_share),
                  onPressed: () {
                    return _invitePeople(
                      context,
                      peer['id'],
                      true,
                    );
                  },
                  tooltip: 'Screen sharing',
                ),
              ],
            ),
          ),
          subtitle: Text('id: ' + peer['id']),
        ),
        Divider(),
      ],
    );
  }
}
