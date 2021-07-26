import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Octave {
  final databaseReference = FirebaseFirestore.instance;

  static Future<Response> getDevice(String name) async {
    Response response;
    try {
      response = await get(
        Uri.parse(
            "https://us-central1-capstonemuop.cloudfunctions.net/device/$name"),
      );
    } catch (e) {
      print(e);
    }
    return response;
  }

  Future<Response> createDevice(String name, String imei, String fsn) async {
    try {
      Response response = await post(
        //https://octave-api.sierrawireless.io/v5.0/capstone_uop2021/device/provision
        //https://us-central1-capstonemuop.cloudfunctions.net/device/provision
        Uri.parse(
            'https://us-central1-capstonemuop.cloudfunctions.net/device/provision'),
        body: {"name": name, "imei": imei, "fsn": fsn},
      );
      return response;
    } catch (e) {
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
