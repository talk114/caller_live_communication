import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeerToPeer extends StatefulWidget {
  @override
  _PeerToPeerState createState() {
    return _PeerToPeerState();
  }
}

class _PeerToPeerState extends State<PeerToPeer> {
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
        title: Text('Peer To Peer Example'),
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(1),
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return _buildRow(context, 'testing');
        },
      ),
    );
  }
}
