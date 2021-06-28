import 'package:flutter/material.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:mup_app/templates/appbar.dart';

const int NumSensors = 5;

class SensorProfilePage extends StatefulWidget {
  SensorProfilePage({Key key}) : super(key: key);

  @override
  _SensorProfilePageState createState() => _SensorProfilePageState();
}

class _SensorProfilePageState extends State<SensorProfilePage> {
  List<bool> _selections = List<bool>.generate(NumSensors, (index) => false);
  bool _atLeastOneSensor = false;

  void _saveProfile() {
    for (var i = 0; i < _selections.length; i++) {
      if (_selections[i]) {
        _atLeastOneSensor = true;
      }
    }
    if (_atLeastOneSensor) {
      _showToast(context);
      Navigator.pop(context);
    }
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

  void _disableVisionProcessor() {
    _selections[1] = false;
  }

  void _disableHumiditySensor() {
    _selections[2] = false;
  }

  void _disableLowPowerMode() {
    _selections[4] = false;
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
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: 100,
                      child: Column(children: [
                        Icon(Icons.thermostat_sharp),
                        Text('Temperature'),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: 100,
                      child: Column(children: [
                        Icon(Icons.visibility),
                        Text('Vision'),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: 100,
                      child: Column(children: [
                        Icon(Icons.water_damage_outlined),
                        Text('Humidity'),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: 100,
                      child: Column(children: [
                        Icon(Icons.waves),
                        Text('Vibration'),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: 100,
                      child: Column(children: [
                        Icon(Icons.power),
                        Text('Power Saver'),
                      ]),
                    ),
                  ],
                  isSelected: _selections,
                  onPressed: (int index) {
                    setState(() {
                      // TODO: Figure out what sensors to select based on profile
                      _selections[index] = !_selections[index];
                      if (index == 4) {
                        _disableVisionProcessor(); //Turn off camera
                        _disableHumiditySensor(); //Turn off humidity
                      } else {
                        _disableLowPowerMode();
                      }
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
