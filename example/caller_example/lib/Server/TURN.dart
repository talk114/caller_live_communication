import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../Helper/outputHelper.dart';

Future<Map> getTurnCredential(String host, int port) async {

  HttpClient client = HttpClient(context: SecurityContext());

  client.badCertificateCallback = (X509Certificate cert, String host, int port) {

    PrintHelper().lprint('getTurnCredential: Allow self-signed certificate => $host:$port. ', false);

    return true;
  };

  // TODO 会在这里改变
  var url = 'https://$host:$port/api/turn?service=turn&username=flutter-webrtc';  

  var request = await client.getUrl(Uri.parse(url));

  var response = await request.close();

  var responseBody = await response.transform(Utf8Decoder()).join();

  PrintHelper().lprint('getTurnCredential:response => $responseBody.', false);

  Map data = JsonDecoder().convert(responseBody);

  return data;
}
