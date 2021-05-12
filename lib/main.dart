import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = FirebaseFirestore.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp()); // Skipping firebase initialization for now while testing
}

class FirebaseInitializer extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Widget error = Text('...error initializing firebase...');
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }

          return CircularProgressIndicator(
            backgroundColor: Colors.blue[50],
          );
        });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUP App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: "Dashboard",
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
  int _counter = 0;
  String _name = "";

  final nameHolder = TextEditingController();

  void clearTextInput() {
    nameHolder.clear();
  }

  void _setName(text) {
    _name = text;
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      databaseReference.collection("flutter_count").add({
        "name": _name,
        "count": _counter,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      }).then((value) {
        print(value.id);
      });

      clearTextInput();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
                alignment: Alignment.center,
                child: TextField(
                  decoration: InputDecoration(hintText: "Name"),
                  controller: nameHolder,
                  onChanged: (text) {
                    _setName(text);
                  },
                ),
                width: MediaQuery.of(context).size.width * 0.5)
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
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.grading_sharp), label: 'System Monitor'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_box), label: "My Account")
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

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
    // setState(() {
    //   // Push device info to firebase
    //   databaseReference.collection("flutter_count").add({
    //     "user": "user1",
    //     "imei": _imei,
    //     "serial": _serial,
    //     "name": _name,
    //     "timestamp": DateTime.now().millisecondsSinceEpoch,
    //   }).then((value) {
    //     print(value.id);
    //   });
    //   clearTextInput();
    // });
    _showToast(context);
    clearTextInput();
    Navigator.pop(context);
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
