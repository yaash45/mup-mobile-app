import 'dart:convert';
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:mup_app/templates/appbar.dart';
//import 'package:permission/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

Map<String, String> SensorNames = {'iaq': 'Indoor Air Quality', 'co2e': 'Carbon Dioxide Equivalent', 'breath_voc': 'Breath VOC',
'temperature' : 'Temperature', 'pressure' : 'Pressure', 
'humidity' : "Humidity"
};

Map<String, IconData> IconValues = {
'humidity': Icons.water_damage_outlined,
'iaq' : Icons.waves,
'co2e' : Icons.waves_rounded,
'pressure': Icons.lock_clock,
'breath_voc' : Icons.whatshot_sharp
};

class DeviceInfo extends StatefulWidget {
  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  var Latitude;
var Longitude;
var deviceIMEI;
  
  GoogleMapController mapController;

  //static final LatLng _center = LatLng(49.246292, -123.116);
  static final LatLng _center = LatLng(49.123151, -122.883925);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setPermissions() async {
    await Permission.location.serviceStatus.isEnabled;
  }

Set<Marker> _createMarker() {
  return {
    Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(49.123151, -122.883925),
        infoWindow: InfoWindow(title: 'Device Location'),
        ),
  };
}
 
 void getImei(String email) async {

 QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance 
    .collection('users')
    .where('email', isEqualTo: email)
    .get();

List<QueryDocumentSnapshot> docs = snapshot.docs;
for (var doc in docs) {
  if (doc.data() != null) {
    var data = doc.data() as Map<String, dynamic>;
    var name = data['fullName']; // You can get other data in this manner. 
     List<dynamic> devices = data['Devices'];
     var devices2 = data['Devices'];
     devices.forEach((element) {
       element.get().then((deviceSnapshot){

      // print(deviceSnapshot.id);
       Map<String,dynamic> devicemap = deviceSnapshot.data();
       Map<String,dynamic> s = devicemap['body'];
       //print(s['report']);
       print(devicemap['body']['summary']['/location/coordinates/value']['v']);
       var lat = jsonDecode(devicemap['body']['summary']['/location/coordinates/value']['v']);
       //print(lat['lat'].runtimeType);
      // setState(() => Latitude = lat['lat']);
      // Latitude = lat['lat'];
      // Longitude = lat['lon'];
      // deviceIMEI = deviceSnapshot.id;
       });
     });
    
  }
}
 }

  //Adding chart
  final List<List<double>> charts = [
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ]
  ];

  static final List<String> chartDropdownItems = [
    'Last 7 days',
    'Last month',
    'Last year'
  ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  @override
  Widget build(BuildContext context) {
  CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
  var email = _currentUser.getCurrentUser.email.toString();
  getImei(email);
  
    return Scaffold(
        appBar: MupAppBar(
          'Device Info',
          leadingBackButton: true,
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          children: <Widget>[
            _buildTile(
                // Padding
                // (
                //   padding: const EdgeInsets.all(1),
                //  child:

                //   Flexible(
                //   child:
                Center(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  heightFactor: 1,
                  widthFactor: 1,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    markers: _createMarker(),
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 9.0,
                    ),
                  ),
                ),
              ),
            )

                //  ),

                ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.teal,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.settings_applications,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Text('General',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                      Text('Images, Videos',
                          style: TextStyle(color: Colors.black45)),
                    ]),
              ),
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.amber,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.notifications,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Text('Alerts',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                      Text('All ', style: TextStyle(color: Colors.black45)),
                    ]),
              ),
            ),
          StreamBuilder(
          stream: FirebaseFirestore.instance.collection("datapoints").where("type", isEqualTo: 'temperature').snapshots(),
          builder: (context, snapshot) {
           if (!snapshot.hasData) {
        return Text(
          'No Data...',
        );
      } else { 
        var type;
        var unit;
        var value;
        var date;
        List<QueryDocumentSnapshot> docs = snapshot.data.docs;
        for (var doc in docs) {
         if (doc.data() != null) {
         var data = doc.data() as Map<String, dynamic>;
         var name = data['value']; 
         print(data['unit'].toString());
         print(name);
         type = data['type'];
         unit = data['unit'];
         value = data['value'].round();
         date =data['timestamp'];
        
        }
        }
        return  _buildTile(
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(type.substring(0,1).toUpperCase() + type.substring(1),
                                  style: TextStyle(color: Colors.blueAccent)
                                  
                                  ),
                              Text(value.toString() + unit.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0)), 
                            ],
                          ),
                          Text(readTimestamp(date),
                                  style: TextStyle(color: Colors.blueAccent)
                                  
                                  ) 
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0, top: 3.0)),
                      Sparkline(
                        data: charts[actualChart],
                        lineWidth: 5.0,
                        lineColor: Colors.greenAccent,
                      )
                    ],
                  )),
            );
      } 
         }),

            ////////
            /*
            _buildTile(
              Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Revenue',
                                  style: TextStyle(color: Colors.green)),
                              Text('\$16K',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0)),
                            ],
                          ),
                          DropdownButton(
                              isDense: true,
                              value: actualDropdown,
                              onChanged: (String value) => setState(() {
                                    actualDropdown = value;
                                    actualChart = chartDropdownItems
                                        .indexOf(value); // Refresh the chart
                                  }),
                              items: chartDropdownItems.map((String title) {
                                return DropdownMenuItem(
                                  value: title,
                                  child: Text(title,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0)),
                                );
                              }).toList())
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Sparkline(
                        data: charts[actualChart],
                        lineWidth: 5.0,
                        lineColor: Colors.greenAccent,
                      )
                    ],
                  )),
            ),
    */
    ////  
    /*    
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Shop Items',
                              style: TextStyle(color: Colors.redAccent)),
                          Text('173',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34.0))
                        ],
                      ),
                      Material(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.store,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
            )
            */
       StreamBuilder(
          stream: FirebaseFirestore.instance.collection("datapoints").where("type", isEqualTo: 'humidity').snapshots(),
          builder: (context, snapshot) {
           if (!snapshot.hasData) {
        return Text(
          'No Data...',
        );
      } else { 
        var type;
        var unit;
        var value;
        var date;
        List<QueryDocumentSnapshot> docs = snapshot.data.docs;
        for (var doc in docs) {
         if (doc.data() != null) {
         var data = doc.data() as Map<String, dynamic>;
         var name = data['value']; 
         type = data['type'];
         unit = data['unit'];
         value = data['value'].round();
         date =data['timestamp'];
        }
        }
        return  _buildDataTab(type.toString(),unit.toString(),value.toString(),date.toString());
        
      }
          }),     
     myStreamBuilder('pressure'),
     myStreamBuilder('iaq'),
     myStreamBuilder('breath_voc')

          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 220.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(1, 180.0),
            
            StaggeredTile.extent(2, 220.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
          ],
        ));
  }
}

String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
Widget _buildTile(Widget child, {Function() onTap}) {
  return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
          onTap: onTap != null
              ? () => onTap()
              : () {
                  print('Not set yet');
                },
          child: child));
}

Widget _buildDataTab (String type, String unit, String value, String date) {
return   _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(SensorNames[type],
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(value + unit,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25.0))
                        ],
                      ),
                      Material(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(IconValues[type],
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
            );
    ////      
}

Widget myStreamBuilder(sensorType){
 return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("datapoints").where("type", isEqualTo: sensorType).snapshots(),
          builder: (context, snapshot) {
           if (!snapshot.hasData) {
        return Text(
          'No Data...',
        );
      } else { 
        var type;
        var unit;
        var value;
        var date;
        List<QueryDocumentSnapshot> docs = snapshot.data.docs;
        for (var doc in docs) {
         if (doc.data() != null) {
         var data = doc.data() as Map<String, dynamic>;
         var name = data['value']; 
         type = data['type'];
         unit = data['unit'];
         value = data['value'].round();
         date =data['timestamp'];
        }
        }
        return  _buildDataTab(type.toString(),unit.toString(),value.toString(),date.toString());
        
      }
          });
}