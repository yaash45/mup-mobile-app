import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'DataPoint.dart';

class DeviceData {
  //String name;
  dynamic name;
  int timeSinceLastSeen;
  int signalBar; 
  String provisioningStatus;
  String signalratvalue;
  bool synced;
  dynamic dataPointList;
  double lat;
  double long;

  DeviceData({
    this.name,
    this.timeSinceLastSeen,
    this.signalBar,
    this.provisioningStatus,
    this.signalratvalue,
    this.synced,
    this.dataPointList,
    this.lat,
    this.long
  });


 factory DeviceData.fromFirebase({List<dynamic> doc}) {

   List<dynamic> sensorvalues = [];
   for (var i = 1; i < doc.length; i++){
    DataPoint newdata = DataPoint.mapData(doc[i]);
    sensorvalues.add(newdata);
   }
   
   return DeviceData(
    //name: doc[2].docs[0]['type'],
    //name: doc[0].data()['body'],
    //name: doc[1].docs[0]['type'],
    name: doc[0].data()['body']['name'],
    timeSinceLastSeen : doc[0].data()['body']['timeSinceLastSeen'],
    signalBar : doc[0].data()['body']['report']['signal']['bar']['value'],
    provisioningStatus : doc[0].data()['body']['provisioningStatus'],
    signalratvalue : doc[0].data()['body']['report']['signal']['rat']['value'],
   // lat: doc[1].docs[0]['lat'],
   // long: doc[1].docs[0]['lon'],
    dataPointList: sensorvalues,
   // temperature: DataPoint.mapData(doc[2]),

    /*
    timeSinceLastSeen : doc.data['body']['timeSinceLastSeen'],
    signalBar : doc.data['body']['report']['signal']['bar']['value'],
    provisioningStatus : doc.data['body']['provisioningStatus'],
    signalratvalue : doc.data['body']['report']['signal']['rat']['value'],
    temperature : doc.data['temperature'],
    */
   );
  }


}