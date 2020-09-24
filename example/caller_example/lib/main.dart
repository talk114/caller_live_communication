import 'package:toast/toast.dart';

import 'Helper/outputHelper.dart';
import 'package:flutter/material.dart';

import 'Helper/outputHelper.dart';

void main() {
  runApp(CallerExample());
}

class CallerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '音素軟件',
      home: CallerExamplePage(title: '音素軟件'),
    );
  }
}

class CallerExamplePage extends StatefulWidget {
  CallerExamplePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CallerExamplePageState createState() {
    return _CallerExamplePageState();
  }
}

class _CallerExamplePageState extends State<CallerExamplePage> {
  // DECLARTION
  String server = '0.0.0.0';

  // LOGIC COMPONENT

  @override
  void initState() {
    super.initState();

    PrintHelper().lprint('启动 Widget.....', false);
  }

  // UI COMPONENT
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        actions: [
          IconButton( onPressed: () {
              PrintHelper().lprint(' 此软件由 John Melody Me 创作', false);
              Toast.show(" 此软件由 John Melody Me 创作", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),),
        ],
      ),
    );
  }
}
