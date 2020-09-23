import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:monjo_live/ui/themes.dart';
import 'package:monjo_live/util/logger.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:toast/toast.dart';
import 'core/permission.dart';

/// <summary>
/// Refer : https://stackoverflow.com/questions/64006635/flutter-unhandled-exception-unable-to-rtcpeerconnectioncreateanswer-error
/// Refer: https://www.reddit.com/r/Coding_for_Teens/comments/iy1iqu/unhandled_exception_unable_to/
/// Refer: https://devrant.com/rants/3079444/i-encountered-this-exception-in-flutter-unhandled-exception-unable-to-rtcpeercon
/// Refer: https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Signaling_and_video_calling
/// Protocol: https://tools.ietf.org/rfc/rfc5761.txt
/// Lobby: https://gitter.im/flutter-webrtc/Lobby
/// </summary>

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
  final TextEditingController sdpController = TextEditingController();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection _peerConnection;
  MediaStream _localStream;
  bool _offer = false;
  String _output = '';

  @override
  dispose() {
    _localRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    requestPermission();
    initRenderers();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });

    // _getUserMedia();
    super.initState();
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

    if (pc != null) print('HERE ==> $pc');

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

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream:' + stream.id);
      _remoteRenderer.srcObject = stream;
    };

    return pc;
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream mediaStream = await navigator.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = mediaStream;
    _localRenderer.mirror = true;

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

    debugPrint(description.toMap().toString(), wrapWidth: 2048);

    _output = description.toMap().toString();

    await _peerConnection.setRemoteDescription(description);
  }

  void _createOffer() async {
    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp);

    print(json.encode(session));

    _offer = true;

    // print('__CREATE_OFFER__');

    print(
      json.encode({
        'sdp': description.sdp.toString(),
        'type': description.type.toString(),
      }),
    );

    _peerConnection.setLocalDescription(description);
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection.createAnswer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp);
    print(json.encode(session));
    debugPrint(json.encode(session), wrapWidth: 2048);
    // print('__CREATE_ANSWER__');
    // print(
    //   json.encode({
    //     'sdp': description.sdp.toString(),
    //     'type': description.type.toString(),
    //   }),
    // );

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
        ),
        RaisedButton(
          onPressed: _createAnswer,
          child: const Text('回应'),
          color: Colors.amber,
        ),
      ],
    );
  }

  Column output() {
    return Column(
      children: [
        Text(_output.toString()),
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
        onChanged: (value) {
          debugPrint("INPUT ==>>>>>>>> $value , ON CHANGES", wrapWidth: 2048);
        },
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
        ),
      ],
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
              print(' 此软件由 John Melody Me 创作');
              Toast.show(" 此软件由 John Melody Me 创作", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            videoRenderers(),
            sdpCandidateTF(),
            offerAndAnswerButton(),
            sdpCandidateButtons(),
            output()
          ],
        ),
      ),
    );
  }

  /// User Interface Components :END///
}
