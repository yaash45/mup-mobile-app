import 'package:flutter/material.dart';

class testView extends StatefulWidget {
  testView({Key key}) : super(key: key);

  @override
  _testViewState createState() => _testViewState();
}

class _testViewState extends State<testView> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('you signed in successfully'),
    );
  }
}