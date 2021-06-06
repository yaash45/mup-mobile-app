import 'package:flutter/material.dart';
import 'package:mup_app/login.dart';
import 'package:mup_app/pages/frequency_profile.dart';
import 'package:mup_app/pages/my_account.dart';
import 'package:mup_app/pages/add_new_device.dart';
import 'package:mup_app/pages/system_health.dart';
import 'package:mup_app/pages/device_info.dart';


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUP App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  final List<Widget> _children = [Dashboard(), SystemHealthPage()
// , MyAccount()
  , DeviceInfo()
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
          onTap: onTappedBar,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.grading_sharp), label: 'System Health'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: "My Account"),
           // BottomNavigationBarItem(
             //   icon: Icon(Icons.important_devices), label: "Device Info")  
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void _selectFrequencyProfilePage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FrequencyProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the dashboard',
            ),
            Container(
              child: ElevatedButton(
                onPressed: _selectFrequencyProfilePage,
                child: Text('Set Frequency Profile'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewDevicePage()))
        },
        tooltip: 'Add new device',
        child: Icon(Icons.add),
      ),
    );
  }
}
