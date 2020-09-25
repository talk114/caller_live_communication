import 'dart:convert';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:random_string/random_string.dart';
import 'package:web_socket_channel/io.dart';

// 信令狀態的回調
typedef void SignalingStateCallback();

// 媒體流的狀態回調
typedef void StreamStateCallback(MediaStream stream);

// 對方入房間的回調
typedef void OtherEventCallback(dynamic event);

enum SignalingState {
  // 呼叫狀態為新
  CallStateNew,

  // 呼叫狀態振鈴
  CallStateRinging,

  // 通話狀態邀請
  CallStateInvite,

  // 通話狀態已連接
  CallStateConnected,

  // 呼叫狀態斷開
  CallStateBye,

  // 連接已打開
  ConnectionOpen,

  // 連接已關閉
  ConnectionClosed,

  // 連接錯誤
  ConnectionError,
}

class RTCSignaling {
  final String _selfID = randomNumeric(6);

  IOWebSocketChannel _channel;

  String _session; // 會話 ID

  String url; // 網絡套接字網址

  String display; // 顯示名稱

  Map _peerConnection = Map<String, RTCPeerConnection>();

  MediaStream _localStream;

  List<MediaStream> _remoteStream;

  SignalingStateCallback onStateChange;

  StreamStateCallback onLocalStream;

  StreamStateCallback onAddRemoteStream;

  StreamStateCallback onRemoveRemoteStream;

  OtherEventCallback onPeersUpdate;

  JsonDecoder _decoder = JsonDecoder();

  JsonEncoder _encoder = JsonEncoder();

  void switchCamera() {
    if (_localStream != null) {
      _localStream.getVideoTracks()[0].switchCamera();
    }
  }

  RTCSignaling(this.url, this.display);
}
