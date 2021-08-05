import 'package:flutter/material.dart';

class SensorProfile {
  SensorProfileItem temperature;
  SensorProfileItem pressure;
  SensorProfileItem humidity;
  SensorProfileItem co2Equivalent;
  SensorProfileItem breathVoc;
  SensorProfileItem iaq;

  SensorProfile() {
    // Temperature
    this.temperature = SensorProfileItem('Temperature', Icon(Icons.thermostat));
    // Pressure
    this.pressure = SensorProfileItem('Pressure', Icon(Icons.crop_square));
    // Humidity
    this.humidity = SensorProfileItem('Humidity', Icon(Icons.waterfall_chart));
    // Co2 Equivalent
    this.co2Equivalent = SensorProfileItem('CO2', Icon(Icons.air));
    // Breath VOC
    this.breathVoc =
        SensorProfileItem('Breath VOC', Icon(Icons.pattern_rounded));
    // IAQ
    this.iaq = SensorProfileItem('IAQ', Icon(Icons.air));
  }

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

  void pushSensorProfileToFirebase(String imei) {
    // TODO: Implement pushing to sensorProfile collection on firebase
    print(this);
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

  SensorProfileItem(String sensorName, Icon icon) {
    this.sensorName = sensorName;
    this.icon = icon;
  }

  void setSensor(bool status) {
    sensorOn = status;
  }
}
