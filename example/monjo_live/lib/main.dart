import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:monjo_live/ui/themes.dart';
import 'package:monjo_live/util/logger.dart';
import 'package:sdp_transform/sdp_transform.dart';
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
  /// START: Logic Components ///
  TextEditingController sdpController = TextEditingController();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection _peerConnection;
  MediaStream _localStream;
  bool _offer = false;

  @override
  void dispose() {
    _localRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    initRenderers();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });

    // _getUserMedia();
  }

  /// Server Changes Here 服务器在此更改
  _createPeerConnection() async {
    Map<String, dynamic> config = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ],
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(config, offerSdpConstraints);

    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode(
          {
            'candidate': e.candidate.toString(),
            'sdpMid': e.sdpMid.toString(),
            'sdpMlineIndex': e.sdpMlineIndex,
          },
        ));
      } else {
        print('无效');
      }
    };

    pc.onAddStream = (stream) {
      print('addStream:' + stream.id);
      _remoteRenderer.srcObject = stream;
    };

    return pc;
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

    return mediaStream;
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
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

  void _setCandidate() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    print(session['candidate']);
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection.addCandidate(candidate);
  }

  void _setRemoteDescription() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

    print(description.toMap());

    await _peerConnection.setRemoteDescription(description);
  }

  void _createOffer() async {
    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp);

    print(json.encode(session));

    _offer = true;

    _peerConnection.setLocalDescription(description);
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection.createAnswer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp);
    print(json.encode(session));

    _peerConnection.setLocalDescription(description);
  }

  /// Logic Components : END ///
  ///
  /// START: User Interface Components ///
  SizedBox videoRenderers() {
    return SizedBox(
      height: 180,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              key: Key('local'),
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: RTCVideoView(_localRenderer),
            ),
          ),
          Flexible(
            child: Container(
              key: Key('remote'),
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: BoxDecoration(color: Colors.black),
              child: RTCVideoView(_localRenderer),
            ),
          ),
        ],
      ),
    );
  }

  Row offerAndAnswerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: _createOffer,
          child: const Text('举行'),
          color: Colors.amber,
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        ),
        RaisedButton(
          onPressed: _createAnswer,
          child: const Text('回应'),
          color: Colors.amber,
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        ),
      ],
    );
  }

  Padding sdpCandidateTF() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: sdpController,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        maxLength: TextField.noMaxLength,
      ),
    );
  }

  Row sdpCandidateButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        /// set  remote description
        RaisedButton(
          onPressed: _setRemoteDescription,
          onLongPress: () {
            var snackBar = SnackBar(
              content: Text('Set  Remote Description'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {},
              ),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
          child: const Text('设置远程描述'),
          color: Colors.amber,
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        ),

        /// set  remote description
        RaisedButton(
          onPressed: _setCandidate,
          onLongPress: () {
            var snackBar = SnackBar(
              content: Text('Set Candicdate'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {},
              ),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
          child: const Text('集合候选'),
          color: Colors.amber,
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Themes.defaultAppBar,
      body: Container(
        child: Column(
          children: <Widget>[
            videoRenderers(),
            sdpCandidateTF(),
            offerAndAnswerButton(),
            sdpCandidateButtons(),
          ],
        ),
      ),
    );
  }

  /// User Interface Components :END///
}
