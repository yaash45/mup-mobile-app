import 'package:flutter/material.dart';

class MyAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Account"), leading: Container()),
        body: Center(child: Text("This is the my account page")));
  }
}
