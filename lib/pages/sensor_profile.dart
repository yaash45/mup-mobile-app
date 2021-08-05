import 'package:flutter/material.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:mup_app/models/SensorProfile.dart';
import 'package:mup_app/templates/appbar.dart';

const int NumSensors = 6;

class SensorProfilePage extends StatefulWidget {
  SensorProfilePage({Key key, this.imei}) : super(key: key);

  final String imei;

  @override
  _SensorProfilePageState createState() => _SensorProfilePageState(this.imei);
}

class _SensorProfilePageState extends State<SensorProfilePage> {
  final String imei;
  _SensorProfilePageState(this.imei);

  SensorProfile _profile = new SensorProfile();
  List<bool> _selections = List<bool>.generate(NumSensors, (index) => true);

  void _saveProfile() {
    _profile.pushSensorProfileToFirebase(imei);
    _showToast(context);
    Navigator.pop(context);
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text("Success: Sensor Profile Set"),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MupAppBar(
        'Sensor Profile',
        leadingBackButton: true,
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(flex: 1),
              Align(
                  alignment: Alignment.center,
                  child: Text('Please select a sensor setting:',
                      style: TextStyle(fontSize: 16))),
              Spacer(flex: 1),
              Align(
                alignment: Alignment.center,
                child: CustomToggleButtons(
                  fillColor: Colors.green[50],
                  splashColor: Colors.transparent,
                  selectedColor: Colors.green[900],
                  selectedBorderColor: Colors.green[500],
                  color: Colors.grey[600],
                  borderWidth: 2.5,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  constraints: BoxConstraints(minWidth: 170),
                  children: [
                    for (var i in _profile.getAllSensorProfileItemsAsList())
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 100,
                        child: Column(children: [
                          i.icon,
                          Text(i.sensorName),
                        ]),
                      ),
                  ],
                  isSelected: _selections,
                  onPressed: (int index) {
                    setState(() {
                      _selections[index] = !_selections[index];
                      _profile.setSensorByIndex(index, _selections[index]);
                    });
                  },
                ),
              ),
              Spacer(
                flex: 6,
              ),
              ElevatedButton(
                child: Text('Save profile'),
                onPressed: _saveProfile,
              ),
              Spacer(
                flex: 1,
              ),
            ],
          )),
    );
  }
}
