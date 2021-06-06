import 'dart:ui';

import 'package:flutter/material.dart';


class DeviceInfo extends StatefulWidget {
  DeviceInfo({Key key}) : super(key: key);

  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 0.2),
      appBar: AppBar(
        title: Text("Device Info"),
      ),
      body:
  //ListView(
  //children: const <Widget>[
  
    Card(
      child: ListTile(
        leading:Card(
          elevation: 15.0,
          margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Image.asset('MUP.png'),
          )),
        title: Text('Two-line ListTile'),
        subtitle: Text('Here is a second line'),
        trailing: Icon(Icons.more_vert),
      ),
    ),
     
    );
  }
}