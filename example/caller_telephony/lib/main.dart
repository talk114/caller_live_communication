import 'package:flutter/material.dart';

void main() {
  runApp(Telephony());
}

class Telephony extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: TelephonyPage(title: '電話軟件'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: null,
    );
  }
}
