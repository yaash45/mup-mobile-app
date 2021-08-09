import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mup_app/models/DeviceData.dart';
import 'package:mup_app/models/FrequencyProfile.dart';
import 'package:mup_app/models/SensorProfile.dart';
import 'package:mup_app/models/UserModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OurDatabase {
  final databaseReference = FirebaseFirestore.instance;

Future<String> downloadURLExample() async {
return FirebaseStorage.instance.refFromURL('https://storage.cloud.google.com/capstonemuop.appspot/decodedimage1.jpg').toString();
   //firebase_storage.ListResult result =
   //   await firebase_storage.FirebaseStorage.instance.ref().listAll();
 //return 'https://storage.cloud.google.com/muop2021/decodedimage1.jpg';
}

  Future<String> createUser(UserModel user) async {
    String retVal = 'error';
    try {
      await databaseReference.collection("users").doc(user.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<UserModel> getUserInfo(String uid) async {
    UserModel retVal = UserModel();
    try {
      DocumentSnapshot _docSnapshot =
          await databaseReference.collection('users').doc(uid).get();
      retVal.uid = uid;
      retVal.fullName = _docSnapshot.get("fullName");
      retVal.email = _docSnapshot.get("email");
      retVal.accountCreated = _docSnapshot.get("accountCreated");
    } catch (e) {
      print(e);
    }

    return retVal;
  }


  Stream<SensorProfile> getSensorProfile(String imei) {
    Stream<DocumentSnapshot> sensorProfile =
        databaseReference.collection('sensorProfile').doc(imei).snapshots();

    return sensorProfile
        .map((snapshot) => SensorProfile.fromJson(snapshot.data()));
  }

Stream<DeviceData> myDevice(String imei, String uid) {
    Stream<DocumentSnapshot> octaveData = databaseReference.collection('devices').doc(imei).snapshots();
    Stream<QuerySnapshot> locationdata = databaseReference.collection('mangoh_resources')
    .where("imei", isEqualTo: int.parse(imei))
    .where('type', isEqualTo: 'location')
    .orderBy("timestamp", descending: true)
    .limit(1)
    .snapshots();
     Stream<QuerySnapshot> tempdata = databaseReference.collection('datapoints')
    .where("imei", isEqualTo: int.parse(imei))
    .where('type', isEqualTo: 'temperature')
    .orderBy("timestamp", descending: true)
    .limit(24)
    .snapshots();
     Stream<QuerySnapshot> humidity = databaseReference.collection('datapoints')
    .where("imei", isEqualTo: int.parse(imei))
    .where('type', isEqualTo: 'humidity')
    .orderBy("timestamp", descending: true)
    .limit(24)
    .snapshots();
    Stream<QuerySnapshot> pressure = databaseReference.collection('datapoints')
    .where("imei", isEqualTo: int.parse(imei))
    .where('type', isEqualTo: 'pressure')
    .orderBy("timestamp", descending: true)
    .limit(24)
    .snapshots();
    Stream<QuerySnapshot> iaq = databaseReference.collection('datapoints')
    .where("imei", isEqualTo: int.parse(imei))
    .where('type', isEqualTo: 'iaq')
    .orderBy("timestamp", descending: true)
    .limit(24)
    .snapshots();
    Stream<QuerySnapshot> breath_voc = databaseReference.collection('datapoints')
    .where("imei", isEqualTo: int.parse(imei))
    .where('type', isEqualTo: 'breath_voc')
    .orderBy("timestamp", descending: true)
    .limit(24)
    .snapshots();
    Stream<QuerySnapshot> co2e = databaseReference.collection('datapoints')
    .where("imei", isEqualTo: int.parse(imei))
    .where('type', isEqualTo: 'co2e')
    .orderBy("timestamp", descending: true)
    .limit(24)
    .snapshots();
    Stream<DocumentSnapshot> imagedecoded = databaseReference.collection('alerts').doc('detectedimage').snapshots();
   
    
    return CombineLatestStream([octaveData,locationdata,tempdata,humidity,
    pressure,iaq,breath_voc,co2e,imagedecoded], (values) => values.toList()).asBroadcastStream().map((snapshot) => DeviceData.fromFirebase(doc: snapshot));
}
  Future<void> pushSensorProfileToFirestore(
      SensorProfile profile, String imei) {
    var updatedSensorProfile = Map<String, dynamic>();
    updatedSensorProfile['temperature'] = profile.temperature.sensorOn;
    updatedSensorProfile['pressure'] = profile.pressure.sensorOn;
    updatedSensorProfile['humidity'] = profile.humidity.sensorOn;
    updatedSensorProfile['co2Equivalent'] = profile.co2Equivalent.sensorOn;
    updatedSensorProfile['breathVoc'] = profile.breathVoc.sensorOn;
    updatedSensorProfile['iaq'] = profile.iaq.sensorOn;

    return databaseReference
        .collection('sensorProfile')
        .doc(imei)
        .set(updatedSensorProfile);
  }

  Stream<FrequencyProfile> getFrequencyProfile(String imei) {
    Stream<DocumentSnapshot> frequencyProfile =
        databaseReference.collection('frequencyProfile').doc(imei).snapshots();

    return frequencyProfile
        .map((snapshot) => FrequencyProfile.fromJson(snapshot.data()));
  }

  Future<void> pushFrequencyProfileToFirestore(
      FrequencyProfile profile, String imei) {
    var updatedFrequencyProfile = Map<String, dynamic>();
    updatedFrequencyProfile['messagesPerHour'] = profile.messagesPerHour;
    updatedFrequencyProfile['preset'] = profile.preset;
    updatedFrequencyProfile['deviceName'] = profile.deviceName;

    return databaseReference
        .collection('frequencyProfile')
        .doc(imei)
        .set(updatedFrequencyProfile);
  }
}
