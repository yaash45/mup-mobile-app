import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:cloud_functions/cloud_functions.dart';




class Octave {
  final databaseReference = FirebaseFirestore.instance;

Future<http.Response> ReadDevice(String name) async{

try {
Response response = await http.get(Uri.parse('https://us-central1-capstonemuop.cloudfunctions.net/device/' + name),
);
return response;

}
catch (e) {
  print(e);
}
}

Future<http.Response> createDevice(String name, String imei, String fsn) async {

try {
Response response = await http.post(
  //https://octave-api.sierrawireless.io/v5.0/capstone_uop2021/device/provision
  //https://us-central1-capstonemuop.cloudfunctions.net/device/provision
    Uri.parse('https://us-central1-capstonemuop.cloudfunctions.net/device/provision'),
    body: {
     "name": name,
     "imei": imei,
     "fsn": fsn
    },
  );
return response;

}
catch(e) {
  print(e);
}
}

/*
Future<void> WaitForDevice() async{
HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('device');
final results = await callable();
print(results.data);
} */
}