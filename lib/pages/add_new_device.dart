import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mup_app/backend/Octave.dart';
import 'package:mup_app/templates/appbar.dart';
import 'package:mup_app/templates/colors.dart';
import '../backend/mup_firebase.dart';
import 'package:provider/provider.dart';
import 'package:mup_app/states/CurrentUser.dart';

class AddNewDevicePage extends StatefulWidget {
  @override
  _AddNewDevicePageState createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends State {
  String _imei = '';
  String _serial = '';
  String _name = '';
  bool _loaded = true;

  final imeiHolder = TextEditingController();
  final serialHolder = TextEditingController();
  final nameHolder = TextEditingController();
  final mupFirestore = new MupFirestore();

  void clearTextInput() {
    imeiHolder.clear();
    serialHolder.clear();
    nameHolder.clear();
  }

  void _beginLoad() {
    setState(() {
      _loaded = false;
    });
  }

  void _completeLoad() {
    setState(() {
      _loaded = true;
    });
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
      }
      /*
        Map<String, dynamic> deviceData = {
          "user": user,
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
    });

    _beginLoad();

    //Creating a device and waiting for the response to be started
    var createdDeviceResponse =
        await Octave().createDevice(_name, _imei, _serial);
    print(createdDeviceResponse.body);

    //Checking is reponse was okay
    if (jsonDecode(createdDeviceResponse.body)['head']['status'] == 201 &&
        jsonDecode(createdDeviceResponse.body)['body']['state'] == "STARTED") {
      //var reponse;
      //var response1 = Future.delayed(const Duration(seconds: 5), () => Octave().ReadDevice(_name));
      //response1.
      //await Octave().ReadDevice(_name);

      Future.delayed(Duration(seconds: 15), () async {
        print(_name);
        var response = await Octave.getDevice(
            jsonDecode(createdDeviceResponse.body)['body']['deviceIds'][0]
                .toString());
        print(response);
        print(jsonDecode(response.body));

        //Grabbing response from Octave
        Map<String, dynamic> data = jsonDecode(response.body);
        var imei = jsonDecode(response.body)['body']['hardware']['imei'];
        //Stored response in devices collection with IMEI as docID
        final databaseReference = FirebaseFirestore.instance;
        databaseReference.collection("devices").doc(imei.toString()).set(data);

        //Grabbing a reference from that device
        DocumentReference reference =
            databaseReference.collection('devices').doc(imei.toString());
        var DevicesList = [reference];

        //Grabbing current users UID
        CurrentUser _currentUser =
            Provider.of<CurrentUser>(context, listen: false);
        var uid = _currentUser.getCurrentUser.uid.toString();

        //Adding device to Users collection with a reference
        databaseReference
            .collection('users')
            .doc(uid)
            .update({'Devices': FieldValue.arrayUnion(DevicesList)});

        _completeLoad();

        clearTextInput();
        _showToast(context,
            "Added device with IMEI = $_imei, Serial = $_serial, Name = $_name");
        Navigator.pop(context);
      });
    }

    /* 
    var response =  await Octave().ReadDevice('jarvin');
    //var response = await Octave().createDevice();
    print(jsonDecode(response.body));
    
    var imei = jsonDecode(response.body)['body']['hardware']['imei'];
    /*
    var empty = jsonDecode(response.body)['body'];
    if (empty?.isEmpty ?? true){
      print('true');
    } */

    print(imei);
    // var response =  await Octave().ReadDevice();
   
    Map<String, dynamic> data = jsonDecode(response.body);
     
    
    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection("devices").doc('jarvin').set(data);
    DocumentReference reference = databaseReference.collection('devices').doc('jarvin');
    var DevicesList = [reference];

    /*
    Map<String, List> userData = {
    'Devices': DevicesList
     }; */
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    var uid = _currentUser.getCurrentUser.uid.toString();

    databaseReference.collection('users').doc(uid).update({
      'Devices': FieldValue.arrayUnion(DevicesList)
    });
    */
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
    return Consumer<CurrentUser>(builder: (context, user, child) {
      var _currentUser = user.getCurrentUser;

      return Scaffold(
        appBar: MupAppBar(
          "Add new device",
          leadingBackButton: true,
        ),
        body: _loaded == true
            ? Padding(
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
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
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
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
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
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
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
                          onPressed: () {
                            _addDevice();
                          },
                          child: Text("Add"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  MupColors.mainTheme)),
                        ),
                        height: 50,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.all(10)),
                    Text('Adding device')
                  ],
                ),
              ),
      );
    });
  }
}

/*
mupFirestore.insertObject('devices', deviceData).then((value) {
          print(value.id);
          clearTextInput();
          _showToast(context,
              "Added device with IMEI = $_imei, Serial = $_serial, Name = $_name");
          Navigator.pop(context);
        }); */
