import 'package:flutter/material.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';

const int NumSensors = 4;

class SensorProfilePage extends StatefulWidget {
  SensorProfilePage({Key key}) : super(key: key);

  @override
  _SensorProfilePageState createState() => _SensorProfilePageState();
}

class _SensorProfilePageState extends State<SensorProfilePage> {
  List<bool> _selections = List<bool>.generate(NumSensors, (index) => true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Select Sensor Profile')),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Text('Please select a sensor setting:')),
                Padding(padding: EdgeInsets.all(5.0)),
                Align(
                  alignment: Alignment.center,
                  child: CustomToggleButtons(
                    fillColor: Colors.blue[50],
                    splashColor: Colors.transparent,
                    selectedColor: Colors.blue[500],
                    selectedBorderColor: Colors.blue[500],
                    borderWidth: 5.0,
                    spacing: 10.0,
                    runSpacing: 10.0,
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
                    ],
                    isSelected: _selections,
                    onPressed: (int index) {
                      setState(() {
                        _selections[index] = !_selections[index];
                      });
                    },
                  ),
                )
              ],
            )));
  }
}
