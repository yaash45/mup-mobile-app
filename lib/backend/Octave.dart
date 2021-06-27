import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';




class Octave {
  final databaseReference = FirebaseFirestore.instance;

Future<http.Response> ReadDevice() async{

try {
Response response = await http.get(Uri.parse('https://octave-api.sierrawireless.io/v5.0/capstone_uop2021/device/raad023'),
headers: {
    'X-Auth-Token'  : 'zPKQ8RgFfaYlqkBel7vvl2PevoA5speV',
    'X-Auth-User'   : "jrivera1",
}
);
return response;

}
catch (e) {
  print(e);
}
}

Future<http.Response> CreateDevice() async {

try {
Response response = await http.post(
    Uri.parse('https://octave-api.sierrawireless.io/v5.0/capstone_uop2021/device/provision'),
    headers: {
    'X-Auth-Token'  : 'zPKQ8RgFfaYlqkBel7vvl2PevoA5speV',
    'X-Auth-User'   : "jrivera1",
    },
    body: jsonEncode(<String, String>{
     "name": "jarvinmangoh",
     "imei":  "352653090202201",
      "fsn": "4L935170340410"
     
    }),
  );
return response;

}
catch(e) {
  print(e);
}
}

}