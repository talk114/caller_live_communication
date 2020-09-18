// 信令状态的回调
import 'dart:convert';

import 'package:flutter_webrtc/webrtc.dart';
import 'package:random_string/random_string.dart';
import 'package:web_socket_channel/io.dart';

typedef void SignallingStateCallBack();

// 媒体流的状态
typedef void StreamStateCallBack(MediaStream stream);

// 对饭加入房间的回调
typedef void OtherEventCallback(dynamic event);

// 信令状态
enum SignallingState {
  CallStateNew, // 进入房间
  CallStateRinging,
  CallStateInvite,
  CallStateConnected, // 连接
  CallStateBye, // 离开
  CallStateOpen,
  CallStateClosed,
  CallStateError,
}

class Signaling {
  final String _selfId = randomNumeric(6);

  String _session; //Conversation ID

  String url; // Websocket

  String display;

  IOWebSocketChannel _channel;

  Map _peerConnections = Map<String, RTCPeerConnection>();

  MediaStream _localMediaStream;

  List<MediaStream> _remoteStreeam;

  SignallingStateCallBack onStateChange;

  StreamStateCallBack onLocalStream;

  StreamStateCallBack onAddRemoteStream;

  StreamStateCallBack onRemoveRemoteStream;

  OtherEventCallback onPeersUpdate;

  JsonDecoder _decoder = JsonDecoder();

  JsonEncoder _encoder = JsonEncoder();
}
