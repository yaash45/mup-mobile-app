import 'package:flutter/material.dart';
import 'package:mup_app/backend/mup_firebase.dart';
import 'package:mup_app/models/Device.dart';
import 'package:mup_app/templates/appbar.dart';
import 'package:mup_app/pages/login.dart';
import 'package:mup_app/pages/frequency_profile.dart';
import 'package:mup_app/pages/my_account.dart';
import 'package:mup_app/pages/add_new_device.dart';
import 'package:mup_app/pages/sensor_profile.dart';
import 'package:mup_app/pages/system_health.dart';
import 'package:mup_app/pages/device_info.dart';
import 'package:mup_app/templates/colors.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          primarySwatch: Colors.blue,
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
  final List<Device> _devices = <Device>[];

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

  void _addDevice(Device device) {
    setState(() {
      if (_devices.isNotEmpty) {
        _devices.forEach((element) => {
              if (element.imei != device.imei) {_devices.add(device)}
            });
      } else {
        _devices.add(device);
      }
    });
  }

  void _deleteDevice(index) {
    String deletedDeviceName = _devices[index].name;
    setState(() {
      _devices.removeAt(index);
    });

    // Then show a snackbar.
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(deletedDeviceName + " deleted")));
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
              onDismissed: (direction) {
                _deleteDevice(index);
              },
              child: MupDeviceCard(device: _devices[index]),
            ));
  }

  void _fetchDeviceList() {
    var _currentUser = Provider.of<CurrentUser>(context, listen: false);
    databaseReference
        .collection('users')
        .where('email', isEqualTo: "${_currentUser.email}")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        List deviceList = element['Devices'];
        deviceList.forEach((device) {
          device.get().then((DocumentSnapshot deviceSnapshot) {
            Map<String, dynamic> deviceData = deviceSnapshot.data();
            _addDevice(
                Device(name: deviceData['name'], imei: deviceSnapshot.id));
          });
        });
      });
    });
  }

  Future<void> _refreshDeviceList() async {
    _fetchDeviceList();
    _createDeviceList();
  }

  @override
  void initState() {
    super.initState();
    _fetchDeviceList();
    _createDeviceList();
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewDevicePage()));
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
        body: RefreshIndicator(
          onRefresh: _refreshDeviceList,
          child: ListView(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            scrollDirection: Axis.vertical,
            children: _createDeviceList(),
          ),
        ));
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

void _setSensorProfilePage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => SensorProfilePage()));
}

class MupDeviceCard extends StatelessWidget {
  MupDeviceCard({Key key, this.device}) : super(key: key);

  final Device device;

  final List<String> _popupMenuItems = <String>[
    'Frequency Profile',
    'Sensor Profile'
  ];
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
            subtitle: Text('Location'),
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
                  _setSensorProfilePage(context);
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
              _deviceInfoPage(context, device.imei);
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
