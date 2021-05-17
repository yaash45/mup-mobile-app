import 'package:flutter/material.dart';
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

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
            "Added device with IMEI = $_imei, Serial = $_serial, Name = $_name"),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _addDevice() {
    setState(() {
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
        _showToast(context);
        Navigator.pop(context);
      });
    });
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
      appBar: AppBar(
        title: Text('Add new device'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: "IMEI"),
                  keyboardType: TextInputType.number,
                  controller: imeiHolder,
                  onChanged: _setImei,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Serial Number"),
                  keyboardType: TextInputType.number,
                  controller: serialHolder,
                  onChanged: _setSerial,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Device name (optional)",
                  ),
                  keyboardType: TextInputType.name,
                  controller: nameHolder,
                  onChanged: _setName,
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: _addDevice,
                      child: Text("Add"),
                    ))
              ],
            ),
          )),
    );
  }
}
