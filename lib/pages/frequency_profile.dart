import 'dart:html';

import 'package:flutter/material.dart';

class FrequencyProfilePage extends StatefulWidget {
  @override
  _FrequencyProfilePageState createState() => _FrequencyProfilePageState();
}

class _FrequencyProfilePageState extends State<FrequencyProfilePage> {
  int _value = 0;
  bool _custom = false;

  void _setFrequencyProfile() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Frequency Profile"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Profile:',
              ),
              DropdownButton(
                value: _value,
                items: [
                  DropdownMenuItem(child: Text('High'), value: 0),
                  DropdownMenuItem(child: Text('Medium'), value: 1),
                  DropdownMenuItem(child: Text('Low'), value: 2),
                  DropdownMenuItem(child: Text('Custom'), value: 3),
                ],
                onChanged: (value) => {
                  setState(() {
                    _value = value;
                    if (_value == 3) {
                      _custom = true;
                    } else {
                      _custom = false;
                    }
                  })
                },
              ),
              _custom ? TextField() : Container(),
              ElevatedButton(
                  onPressed: _setFrequencyProfile, child: Text('Set')),
            ],
          ),
        ));
  }
}
