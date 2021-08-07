import 'package:flutter/material.dart';

class SensorProfile {
  SensorProfileItem temperature;
  SensorProfileItem pressure;
  SensorProfileItem humidity;
  SensorProfileItem co2Equivalent;
  SensorProfileItem breathVoc;
  SensorProfileItem iaq;

  SensorProfile(
      {this.temperature,
      this.pressure,
      this.humidity,
      this.co2Equivalent,
      this.breathVoc,
      this.iaq});

  SensorProfile.fromJson(Map<String, dynamic> parsedJson)
      : temperature = SensorProfileItem(
          sensorName: 'Temperature',
          icon: Icon(Icons.thermostat),
          sensorOn: parsedJson['temperature'],
        ),
        pressure = SensorProfileItem(
          sensorName: 'Pressure',
          icon: Icon(Icons.crop_square),
          sensorOn: parsedJson['pressure'],
        ),
        humidity = SensorProfileItem(
          sensorName: 'Humidity',
          icon: Icon(Icons.waterfall_chart),
          sensorOn: parsedJson['humidity'],
        ),
        co2Equivalent = SensorProfileItem(
          sensorName: 'CO2',
          icon: Icon(Icons.air),
          sensorOn: parsedJson['co2Equivalent'],
        ),
        breathVoc = SensorProfileItem(
          sensorName: 'Breath VOC',
          icon: Icon(Icons.pattern_rounded),
          sensorOn: parsedJson['breathVoc'],
        ),
        iaq = SensorProfileItem(
          sensorName: 'IAQ',
          icon: Icon(Icons.air),
          sensorOn: parsedJson['iaq'],
        );

  List<SensorProfileItem> getAllSensorProfileItemsAsList() {
    return [
      this.temperature,
      this.pressure,
      this.humidity,
      this.co2Equivalent,
      this.breathVoc,
      this.iaq
    ];
  }

  Map<int, SensorProfileItem> getAllSensorProfileItemsAsMap() {
    return this.getAllSensorProfileItemsAsList().asMap();
  }

  int getSensorCount() {
    return this.getAllSensorProfileItemsAsList().length;
  }

  void setSensorByIndex(int index, bool status) {
    this.getAllSensorProfileItemsAsList()[index].setSensor(status);
  }

  @override
  String toString() {
    String result = "";

    for (var i in this.getAllSensorProfileItemsAsList()) {
      result += "sensorName: ${i.sensorName}, on: ${i.sensorOn}\n";
    }

    return result;
  }
}

class SensorProfileItem {
  String sensorName;
  Icon icon;
  bool sensorOn = true;

  SensorProfileItem({this.sensorName, this.icon, this.sensorOn});

  void setSensor(bool status) {
    sensorOn = status;
  }
}
