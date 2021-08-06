import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mup_app/models/DeviceData.dart';
import 'package:mup_app/models/FrequencyProfile.dart';
import 'package:mup_app/models/SensorProfile.dart';
import 'package:mup_app/models/UserModel.dart';
import 'package:rxdart/rxdart.dart';

class OurDatabase {
  final databaseReference = FirebaseFirestore.instance;

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

  Stream<DeviceData> myDevice(String imei, String uid) {
    Stream<DocumentSnapshot> octaveData =
        databaseReference.collection('devices').doc(imei).snapshots();
    Stream<QuerySnapshot> tempdata = databaseReference
        .collection('datapoints')
        .where("imei", isEqualTo: int.parse(imei))
        .where('type', isEqualTo: 'temperature')
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots();

    return CombineLatestStream(
            [octaveData, tempdata], (values) => values.toList())
        .asBroadcastStream()
        .map((snapshot) => DeviceData.fromFirebase(doc: snapshot));
  }

  Stream<SensorProfile> getSensorProfile(String imei) {
    Stream<DocumentSnapshot> sensorProfile =
        databaseReference.collection('sensorProfile').doc(imei).snapshots();

    return sensorProfile
        .map((snapshot) => SensorProfile.fromJson(snapshot.data()));
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

    return databaseReference
        .collection('frequencyProfile')
        .doc(imei)
        .set(updatedFrequencyProfile);
  }
}
