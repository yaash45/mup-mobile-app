import 'package:flutter/material.dart';
import 'package:mup_app/backend/mup_firebase.dart';

class SystemHealthPage extends StatefulWidget {
  @override
  _SystemHealthPageState createState() => _SystemHealthPageState();
}

class _SystemHealthPageState extends State<SystemHealthPage> {
  final mupFirestore = new MupFirestore();

  int _counter = 0;

  void _setData() {
    _counter++;
  }

  void onPressed() {
    setState(() {
      _setData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('System Health')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(padding: EdgeInsets.all(10.0), child: Text("$_counter")),
            Container(
                padding: EdgeInsets.all(10.0),
                child:
                    ElevatedButton(onPressed: onPressed, child: Text('Fetch'))),
          ],
        ),
      ),
    );
  }
}
