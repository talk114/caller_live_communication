// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'util/logger.dart';
// import 'util/permission.dart';
// import 'package:flutter/material.dart';
// import 'ui/themes.dart';

// void main() {
//   runApp(MonjoLivePrototype());
// }

// class MonjoLivePrototype extends StatefulWidget {
//   @override
//   _MonjoLivePrototypeState createState() => _MonjoLivePrototypeState();
// }

// /// Options
// enum DialogueAction {
//   cancel,
//   connect,
// }

// class _MonjoLivePrototypeState extends State<MonjoLivePrototype> {
//   SharedPreferences _preferences;
//   String _server = '';
//   bool _isChannelDeclared = false;

//   @override
//   void initState() {
//     super.initState();

//     logger("Widget Started");

//     /// Request Permission
//     if (Platform.isAndroid) {
//       AndroidOperatingSystemPermission();
//     } else if (Platform.isIOS) {
//       IOSOperatingSystemPermission();
//     }

//     _initData();
//   }

//   /// __init__ data
//   _initData() async {
//     _preferences = await SharedPreferences.getInstance();
//     setState(() {
//       _server = _preferences.getString('server') ?? 'demo.cloudwebrtc.com';
//       logger("connected To $_server");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: Themes.defaultTheme,
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           leading: GestureDetector(
//             onTap: () {
//               exit(0);
//               showAlertDialog(context);
//             },
//             child: Icon(
//               Icons.close,
//             ),
//           ),
//           primary: true,
//           backgroundColor: Colors.pink,
//           title: Text('Monjo Live Call'),
//           actions: <Widget>[
//             FlatButton.icon(
//               label: Text(''),
//               onPressed: () {
//                 logger('User making a Call');
//                 _isChannelDeclared = true;
//                 _showAddressDialog(context);
//               },
//               icon: Icon(Icons.phone_iphone),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         body: Column(
//           children: <Widget>[],
//         ),
//       ),
//     );
//   }

//   showAlertDialog(BuildContext context) {
//     Widget btnExit = RaisedButton(
//       onPressed: () {
//         exit(0);
//       },
//       child: Text('Yes'),
//     );

//     AlertDialog alertUser = AlertDialog(
//       title: Text("John: "),
//       content:
//           Text("Think again , do you really want to exit this application?"),
//       actions: [
//         btnExit,
//       ],
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alertUser;
//       },
//     );
//   }

//   userMakingCall<T>({BuildContext context, Widget widget}) {
//     showDialog<T>(
//       context: context,
//       builder: (BuildContext context) {
//         return widget;
//       },
//     ).then<void>(
//       (T value) {
//         if (value != null) {
//           if (value == DialogueAction.connect) {
//             _preferences.setString('server', _server);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (BuildContext context) {
//                   if (_isChannelDeclared) {
//                     // return customsipsever(ip: _server);
//                     logger('<SIP> Custom');
//                   } else {
//                     // return Default Example (ip: _server);
//                   }
//                 },
//               ),
//             );
//           }
//         }
//       },
//     );
//   }

//   _showAddressDialog(context) {
//     userMakingCall<DialogueAction>(
//       context: context,
//       widget: AlertDialog(
//         title: const Text('Enter  your custom server address:'),
//         content: TextField(
//           onChanged: (String text) {
//             setState(() {
//               _server = text;
//             });
//           },
//           decoration: InputDecoration(
//             hintText: _server,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.pop(
//                 context,
//                 DialogueAction.cancel,
//               );
//             },
//           ),
//           FlatButton(
//             child: const Text('Connect'),
//             onPressed: () {
//               Navigator.pop(
//                 context,
//                 DialogueAction.connect,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
