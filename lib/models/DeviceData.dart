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
  DataPoint temperature;
  
  

  DeviceData({
    this.name,
    this.timeSinceLastSeen,
    this.signalBar,
    this.provisioningStatus,
    this.signalratvalue,
    this.synced,
    this.temperature,
  });


 factory DeviceData.fromFirebase({List<dynamic> doc}) {
   
   return DeviceData(
    name: doc[1].docs[0]['timestamp'],
    
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