import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mup_app/backend/mup_firebase.dart';

class SystemHealthPage extends StatefulWidget {
  @override
  _SystemHealthPageState createState() => _SystemHealthPageState();
}

class _SystemHealthPageState extends State<SystemHealthPage> {
  final mupFirestore = new MupFirestore();

  List<Widget> _firestoreDataWidgets = [];

  List<Widget> _createFirestoreDataWidgets() {
    return new List<Widget>.generate(
        _firestoreDataWidgets.length, (index) => _firestoreDataWidgets[index]);
  }

  void _appendData(String data) {
    _firestoreDataWidgets.add(Text(data));
  }

  void _fetch() {
    mupFirestore
        .getObjectByCollection('devices')
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          _appendData(element.data().toString());
        });
      });
    });
  }

  void _clear() {
    setState(() {
      _firestoreDataWidgets.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Health'),
        leading: Container(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: _createFirestoreDataWidgets()),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: _fetch, child: Text('Fetch')),
                    ElevatedButton(onPressed: _clear, child: Text('Clear')),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
