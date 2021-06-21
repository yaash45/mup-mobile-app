import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUP App',
      theme: ThemeData(
        primarySwatch: MupColors.createMaterialColor(MupColors.mainTheme),
      ),
      home: Login(),
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
  final List<Widget> _children = [Dashboard(), SystemHealthPage(), MyAccount()];

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
            iconData: Icons.grading_sharp,
            label: 'System Health',
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
  @override
  Widget build(BuildContext context) {
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
        body: MupDeviceCard());
  }
}

class MupDeviceCard extends StatelessWidget {
  const MupDeviceCard({Key key}) : super(key: key);

  void _deviceInfoPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (contect) => DeviceInfo()));
  }

  void _selectFrequencyProfilePage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FrequencyProfilePage()));
  }

  void _setSensorProfilePage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SensorProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 150.0,
            width: 350.0,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Device 1",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _deviceInfoPage(context);
                        },
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: Text(
                            "Device Info",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _selectFrequencyProfilePage(context);
                        },
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: Text(
                            "Frequency Profile",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _setSensorProfilePage(context);
                        },
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: Text(
                            "Sensor Profile",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // MORE DEVICE WIDGETS CAN BE ADDED HERE
        ],
      ),
    );
  }
}
