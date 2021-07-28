import 'package:cloud_firestore/cloud_firestore.dart';

class DataPoint {
  int timestamp;
  String type;
  String unit;
  var value; 

  DataPoint({
    this.timestamp,
    this.type,
    this.unit,
    this.value,
  });

  factory DataPoint.mapData(QuerySnapshot doc) {
   
   return DataPoint(
     timestamp: doc.docs[0]['timestamp'],
     type: doc.docs[0]['type'],
     unit: doc.docs[0]['unit'],
     value: doc.docs[0]['value'],
   );
  }
}
