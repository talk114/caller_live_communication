import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:monjo_live/util/logger.dart';

Future<Map> getTurnCredential(String host, int port) async {
  HttpClient client = HttpClient(context: SecurityContext());

  client.badCertificateCallback =
    (X509Certificate cert, String host, int port) {
    logger('getTurnCredential: Allow self-signed certificate => $host:$port. ');
    return true;
  };

  String url = 'https://$host:$port/api/turn?service=turn&username=flutter-webrtc';
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String responseBody = await response.transform(Utf8Decoder()).join();
  logger('getTurnCredential:response => $responseBody.');
  Map data = JsonDecoder().convert(responseBody);
  return data;
}
