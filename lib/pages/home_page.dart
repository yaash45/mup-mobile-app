import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mup_app/backend/Octave.dart';
import 'package:mup_app/backend/mup_firebase.dart';
import 'package:mup_app/models/Device.dart';
import 'package:mup_app/templates/appbar.dart';
import 'package:mup_app/pages/login.dart';
import 'package:mup_app/pages/frequency_profile.dart';
import 'package:mup_app/pages/my_account.dart';
import 'package:mup_app/pages/add_new_device.dart';
import 'package:mup_app/pages/sensor_profile.dart';
import 'package:mup_app/pages/device_info.dart';
import 'package:mup_app/templates/colors.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

enum AuthStatus {
  unAuthenticated,
  Authenticated,
}

AuthStatus _authStatus = AuthStatus.unAuthenticated;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        title: 'MUP App',
        theme: ThemeData(
          primarySwatch: MupColors.appSwatch,
        ),
        // home: Login(),
        home: authWidget(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [Dashboard(), MyAccount()];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Colors.white,
          selectedItemBackgroundColor: MupColors.mainTheme,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: _currentIndex,
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.list_alt_rounded,
            label: 'Devices',
            animationDuration: Duration(milliseconds: 1500),
          ),
          FFNavigationBarItem(
            iconData: Icons.account_box_rounded,
            label: 'My Account',
            animationDuration: Duration(milliseconds: 1500),
          ),
        ],
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<DeviceCard> _devices = <DeviceCard>[];
  bool _loaded;

  // https://blog.usejournal.com/implementing-swipe-to-delete-in-flutter-a742e041c5dd
  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 25.0),
      color: Colors.red,
      child: Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
      ),
    );
  }

  void _clearDeviceList() {
    setState(() {
      _devices.clear();
    });
  }

  void _addDevice(DeviceCard device) {
    setState(() {
      _devices.add(device);
    });
  }

  Future<void> _deleteDevice(index) async {
    String deletedDeviceName = _devices[index].name;
    String deletedDeviceImei = _devices[index].imei;
    var _currentUser = Provider.of<CurrentUser>(context, listen: false);

    print('in delete device');

    Response response = await Octave.deleteDevice(
        deletedDeviceName, deletedDeviceImei, _currentUser.email);

    // Delete sensor profile for device
    databaseReference
        .collection('sensorProfile')
        .doc(deletedDeviceImei)
        .delete();

    print('delete response = ' + response.body.toString());

    if (response.statusCode == 200) {
      // Then show a snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(deletedDeviceName + " deleted")));
      await _fetchDeviceListFromFirebase();
    } else {
      // Then show a snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not delete device. Internal error.')));
    }
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

  List<Widget> _createDeviceList() {
    return new List<Widget>.generate(
        _devices.length,
        (index) => Dismissible(
              confirmDismiss: (direction) async {
                return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm delete'),
                        content: Text(
                            "Are you sure you wish to delete ${_devices[index].name}?"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("DELETE",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL",
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      );
                    });
              },
              key: Key(_devices[index].name),
              background: stackBehindDismiss(),
              onDismissed: (direction) async {
                await _deleteDevice(index);
              },
              child: MupDeviceCard(device: _devices[index]),
            ));
  }

  DeviceStatus _deviceStatusFromOctaveResponse(
      Map<String, dynamic> deviceData) {
    return jsonEncode(deviceData['body']['report']) == jsonEncode({})
        ? DeviceStatus.PENDING
        : DeviceStatus.READY;
  }

  Future<void> _fetchDeviceListFromFirebase() async {
    var _currentUser = Provider.of<CurrentUser>(context, listen: false);

    _clearDeviceList();

    databaseReference
        .collection('users')
        .where('email', isEqualTo: "${_currentUser.email}")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((QueryDocumentSnapshot<Object> element) {
        try {
          var deviceList = element.get('Devices');
          if (deviceList != null) {
            deviceList.forEach((device) {
              device.get().then((DocumentSnapshot deviceSnapshot) {
                Map<String, dynamic> deviceData = deviceSnapshot.data();
                _addDevice(
                  DeviceCard(
                    name: deviceData['body']['name'],
                    imei: deviceSnapshot.id,
                    status: _deviceStatusFromOctaveResponse(deviceData),
                  ),
                );
              });
            });
          }
        } catch (StateError) {
          print("No devices found for user");
        }
      });
    });
  }

  Future<void> _fetchDeviceInfoFromOctave() async {
    print('mapping device list to device names...');
    _beginLoad();
    print('loaded = ' + _loaded.toString());
    List<String> _deviceNames =
        _devices.map((deviceCard) => deviceCard.name).toList();
    print('mapped list = ' + _deviceNames.toString());
    List<DeviceCard> recentlyFetchedFromCloudFunction = [];

    _clearDeviceList();

    for (var name in _deviceNames) {
      print('fetching ' + name + ' from Octave');
      Response response = await Octave.getDevice(name);
      Map<String, dynamic> deviceData = jsonDecode(response.body);
      print('fetched ' +
          deviceData['body']['name'] +
          ", " +
          deviceData['body']['hardware']['imei'] +
          ' from Octave');
      if (response.statusCode == 200) {
        var latestDeviceCard = DeviceCard(
          imei: deviceData['body']['hardware']['imei'],
          name: deviceData['body']['name'],
          status: _deviceStatusFromOctaveResponse(deviceData),
        );

        print('pushing ' +
            latestDeviceCard.name +
            ', ' +
            latestDeviceCard.imei +
            ' to firebase');
        //Push latest info for device to firebase
        databaseReference
            .collection("devices")
            .doc(latestDeviceCard.imei)
            .set(deviceData);

        //Append device to device list on UI
        _addDevice(latestDeviceCard);
      } else {
        break;
      }
      print('fetched device list =  ' + _devices.toString());
    }
    _completeLoad();
    print('completed load = ' + _loaded.toString());
  }

  Future<void> _refreshDeviceList() async {
    _fetchDeviceInfoFromOctave();
  }

  @override
  void initState() {
    super.initState();
    _fetchDeviceListFromFirebase();
    _completeLoad();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("did change dependencieees");
    //get the state, check the user, set AuthStatus based on state
    CurrentUser _currentuser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentuser.onStartUp();

    if (_returnString == 'success') {
      setState(() {
        _authStatus = AuthStatus.Authenticated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //CurrentUser _currentuser = Provider.of<CurrentUser>(context, listen: false);
    // print(_currentuser.getCurrentUser.email);
    return Scaffold(
      appBar: MupAppBar(
        'Devices',
        actions: [
          IconButton(
            splashRadius: 28,
            alignment: Alignment.center,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddNewDevicePage()));
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            iconSize: 28,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          ),
        ],
      ),
      body: _loaded == true
          ? RefreshIndicator(
              onRefresh: _refreshDeviceList,
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                scrollDirection: Axis.vertical,
                children: _createDeviceList(),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text('Checking activation status...')
                ],
              ),
            ),
    );
  }
}

void _deviceInfoPage(BuildContext context, String imei) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (contect) => DeviceInfo(
                deviceImei: imei,
              )));
}

void _selectFrequencyProfilePage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => FrequencyProfilePage()));
}

void _setSensorProfilePage(BuildContext context, String imei) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SensorProfilePage(
                imei: imei,
              )));
}

class MupDeviceCard extends StatelessWidget {
  MupDeviceCard({Key key, this.device}) : super(key: key);

  final DeviceCard device;

  final List<String> _popupMenuItems = <String>[
    'Frequency Profile',
    'Sensor Profile'
  ];

  void _showDeviceNotReadyDialog(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
          title: Text('Pending Device Activation'),
          content: Text(
              'This can take upto 20 minutes. Please refresh in sometime to check if your device is ready. Thank you for your patience.'),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: Text('Pending Device Activation'),
          content: Text(
              'This can take upto 20 minutes. Please refresh in sometime to check if your device is ready. Thank you for your patience.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 14,
      shadowColor: MupColors.shadowColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.5, color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              this.device.name,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  children: [
                    Text('Status: '),
                    this.device.status == DeviceStatus.PENDING
                        ? Text(
                            'PENDING',
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            'READY',
                            style: TextStyle(color: Colors.green),
                          )
                  ],
                )),
            trailing: PopupMenuButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              onSelected: (choice) {
                if (choice == 'Frequency Profile') {
                  _selectFrequencyProfilePage(context);
                } else if (choice == 'Sensor Profile') {
                  _setSensorProfilePage(context, this.device.imei);
                }
              },
              itemBuilder: (BuildContext context) {
                return _popupMenuItems.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice, child: Text(choice));
                }).toList();
              },
            ),
            dense: false,
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            enableFeedback: true,
            onTap: () {
              if (device.status == DeviceStatus.READY) {
                _deviceInfoPage(context, device.imei);
              } else {
                _showDeviceNotReadyDialog(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget authWidget() {
  Widget retVal;

  switch (_authStatus) {
    case AuthStatus.unAuthenticated:
      retVal = Login();
      break;
    case AuthStatus.Authenticated:
      retVal = MyHomePage(title: "myapp");
      break;
    default:
  }
  return retVal;
}
