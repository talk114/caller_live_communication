import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:monjo_live/network/signaling.dart';


class PeerToPeer extends StatefulWidget {
  final String url;

  PeerToPeer({Key key, @required this.url}) : super(key: key);

  @override
  _PeerToPeerState createState() {
    return _PeerToPeerState(serverUrl: url);
  }
}

class _PeerToPeerState extends State<PeerToPeer> {
  String serverUrl;
  String _displayName =
      '${Platform.localeName.substring(0, 2)} + (${Platform.operatingSystem})';
  Signaling _signaling;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  List<dynamic> _peers;
  var _selfId;

  _PeerToPeerState({
    Key key,
    @required this.serverUrl,
  });

  _connect() {
    print('connecting....');
  }

  Widget _buildRow(context, peer) {
    return ListBody(
      children: <Widget>[
        ListTile(
          title: Text(peer),
          trailing: SizedBox(
              width: 100,
              child: IconButton(
                onPressed: _connect(),
                icon: Icon(
                  Icons.videocam,
                ),
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '对等实例',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.cyan,
      ),
      body: _inCalling
          ? OrientationBuilder(
              builder: (BuildContext context, orientation) {
                Container(
                    child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: RTCVideoView(_remoteRenderer),
                        decoration: BoxDecoration(color: Colors.green),
                      ),
                    ),
                    Positioned(
                        right: 20.0,
                        top: 20.0,
                        child: Container(
                          width: orientation == Orientation.portrait
                              ? 90.0
                              : 120.0,
                          height: orientation == Orientation.portrait
                              ? 120.0
                              : 90.0,
                          child: RTCVideoView(_localRenderer),
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                        )),
                  ],
                ));
              },
            )
          : ListView.builder(
              padding: EdgeInsets.all(1),
              itemCount: (_peers != null) ? _peers.length : 3,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                // return _buildRow(context, _peers[i]);
                return _buildRow(context, _displayName);
              },
            ),
    );
  }
}
