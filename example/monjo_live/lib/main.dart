import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:monjo_live/p2p.dart';
import 'package:monjo_live/ui/themes.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'WEBRTC JANUS',
      darkTheme: Themes.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: CallerExample(),
    ),
  );
}

class CallerExample extends StatefulWidget {
  CallerExample({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CallerExampleState createState() => _CallerExampleState();
}

class _CallerExampleState extends State<CallerExample> {
  _enterRoom() {
    print('Entering Room...');
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => PeerToPeer()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: debugBrightnessOverride,
        backgroundColor: Colors.cyan,
        title: Text('WEBRTC JANUS'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: _enterRoom,
          child: Text('Enter Room'),
        ),
      ),
    );
  }
}
