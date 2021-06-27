import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mup_app/backend/Octave.dart';
import 'package:mup_app/templates/appbar.dart';
import 'package:mup_app/templates/colors.dart';
import '../backend/mup_firebase.dart';

class AddNewDevicePage extends StatefulWidget {
  @override
  _AddNewDevicePageState createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends State {
  String _imei = '';
  String _serial = '';
  String _name = '';

  final imeiHolder = TextEditingController();
  final serialHolder = TextEditingController();
  final nameHolder = TextEditingController();
  final mupFirestore = new MupFirestore();

  void clearTextInput() {
    imeiHolder.clear();
    serialHolder.clear();
    nameHolder.clear();
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _addDevice() async {
    /*
    setState(() {
      if (_imei == '') {
        _showToast(context, "Please enter IMEI number for your device");
      } else if (_serial == '') {
        _showToast(context, "Please enter Serial number for your device");
      } else {
        if (_name == '') {
          // TODO: Get device count for account and set name accordingly
          _name = 'mangoh-1';
        }
        /*
        Map<String, dynamic> deviceData = {
          "user": "test",
          "imei": _imei,
          "serial": _serial,
          "name": _name,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
        };

        // Push device info to firebase
        mupFirestore.insertObject('devices', deviceData).then((value) {
          print(value.id);
          clearTextInput();
          _showToast(context,
              "Added device with IMEI = $_imei, Serial = $_serial, Name = $_name");
          Navigator.pop(context);
        });
      } */
      
    }
    ); */
    //var createdDeviceResponse = await Octave().CreateDevice();
    //print(createdDeviceResponse.body);
     
     var response =  await Octave().ReadDevice();
     Map<String, dynamic> data = jsonDecode(response.body);
     
     final databaseReference = FirebaseFirestore.instance;
     databaseReference.collection("devices").doc("352653090202201").set(data);
    DocumentReference reference = databaseReference.collection('devices').doc('352653090202201');
    var DevicesList = [reference];
    Map<String, List> userData = {
    'Devices': DevicesList
     };

    databaseReference.collection('users').doc('HEbxCQEvNHYSmwp9orEW2ViWWA13').update(userData);

    print("yes");
    

  }

  void _setImei(imei) {
    _imei = imei;
  }

  void _setSerial(serial) {
    _serial = serial;
  }

  void _setName(name) {
    _name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MupAppBar(
        'Add new device',
        leadingBackButton: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "IMEI",
                    hintText: "Please check your device for IMEI",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: imeiHolder,
                  onChanged: _setImei,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Serial Number",
                    hintText: "Please check your device for Serial No.",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: serialHolder,
                  onChanged: _setSerial,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Device name",
                    hintText: "This is your device nickname",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  controller: nameHolder,
                  onChanged: _setName,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: _addDevice,
                    child: Text("Add"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(MupColors.mainTheme)),
                  ),
                  height: 50,
                  width: double.infinity,
                ),
              ],
            ),
          )),
    );
  }
}
