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
  dynamic test;
  List<dynamic> DatapointList;
  double lat;
  double lon;
  dynamic signalStrength;
  List<dynamic> TempList;

  

  DeviceData({
    this.name,
    this.timeSinceLastSeen,
    this.signalBar,
    this.provisioningStatus,
    this.signalratvalue,
    this.synced,
    this.test,
    this.DatapointList,
    this.lat,
    this.lon,
    this.signalStrength,
    this.TempList,
  });


 factory DeviceData.fromFirebase({List<dynamic> doc}) {
   
   return DeviceData(
    name: doc[0].data()['body']['name'],

    timeSinceLastSeen: doc[0].data()['body']['timeSinceLastSeen'],
    signalBar : doc[0].data()['body']['report']['signal']['bars']['value'],
    provisioningStatus : doc[0].data()['body']['provisioningStatus'],
    signalratvalue : doc[0].data()['body']['report']['signal']['rat']['value'],
    lat: doc[1].docs[0]['lat'],
    lon: doc[1].docs[0]['lon'], 
    signalStrength: doc[0].data()['body']['report']['signal']['strength']['value'],

    test: doc[2].docs[0]['type'],
    DatapointList: [doc[2].docs[0],doc[3].docs[0],doc[4].docs[0],doc[5].docs[0],doc[6].docs[0],
    doc[7].docs[0]],
    //
    TempList: [doc[2].docs,doc[3].docs,doc[4].docs,doc[5].docs,doc[6].docs,
    doc[7].docs]
    


    
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