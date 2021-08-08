import 'dart:convert';
import 'dart:math';
import 'dart:ui';
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mup_app/backend/database.dart';
import 'package:mup_app/models/DeviceData.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:mup_app/templates/appbar.dart';
//import 'package:permission/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:badges/badges.dart';

Map<String, String> SensorNames = {'iaq': 'IndoorAirQuality', 'co2e': 'Co2 Equivalent', 'breath_voc': 'Breath VOC',
'temperature' : 'Temperature', 'pressure' : 'Pressure', 
'humidity' : "Humidity"
};

Map<String, IconData> IconValues = {
'humidity': Icons.water_damage_outlined,
'iaq' : Icons.waves,
'co2e' : Icons.waves_rounded,
'pressure': Icons.lock_clock,
'breath_voc' : Icons.whatshot_sharp,
'temperature' : Icons.thermostat_outlined
};

Map<bool, IconData> BatteryConnected = {
  true: Icons.battery_charging_full_rounded,
  false: Icons.battery_unknown_outlined,
};
class DeviceInfo extends StatefulWidget {
  final String deviceImei;

  DeviceInfo({Key key, this.deviceImei}) : super(key: key);

  @override
  _DeviceInfoState createState() => _DeviceInfoState(this.deviceImei);
}

class _DeviceInfoState extends State<DeviceInfo> {
  final String deviceImei;
  _DeviceInfoState(this.deviceImei);

  GoogleMapController mapController;

  //static final LatLng _center = LatLng(49.246292, -123.116);
  static final LatLng _center = LatLng(49.123151, -122.883925);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setPermissions() async {
    await Permission.location.serviceStatus.isEnabled;
  }

Set<Marker> _createMarker(double lat , double lon) {
  return {
    Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(title: 'Device Location'),
        ),
  };
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
  List<double> tilesize =[
    220.0,
    180.0,
    180.0,  

    90.0,
    90.0,
    90.0,
    90.0,
    90.0,
    90.0,
   
  ];
  List<double> originaltilesizes =[
    220.0,
    180.0,
    180.0, 
    90.0,
    90.0,
    90.0,
    90.0,
    90.0,
    90.0,
    
  ];

  Widget tileswitch(int index){
    setState(() {
      
          if(tilesize[index] != 400){
          tilesize[index]= 400;
          }
          else {
            tilesize[index]=originaltilesizes[index];
          }
        });
  }
  Widget _buildTile( int indexnum,Widget child, {Function() onTap}) {
  return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
          /* onTap: onTap != null
              ? () => onTap()
              : () {
                  print('Not set yet');
                }, */
          onTap: () => {
            tileswitch(indexnum)
           
          },
          child: child));
}
 Widget _buildPrelimTile(Widget child, {Function() onTap}) {
  return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
      child: child));
}
String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'd';
      } else {
        time = diff.inDays.toString() + ' d';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + 'W';
      } else {

        time = (diff.inDays / 7).floor().toString() + 'W';
      }
    }

    return time;
  }
Widget _buildDataTab (String type, String unit, String value, String date, int indexnum) {
return   _buildTile(
              indexnum,
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
                          )
                          )
                          )
                    ]),
              ),
            );
    ////      
}

List<CartesianChartAnnotation> annotations = [
CartesianChartAnnotation( 
                        widget: Container(
                        child: Text("1", style: TextStyle(color: Colors.red)),
                         // margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                         )),
                         coordinateUnit: CoordinateUnit.point,
                        // region: AnnotationRegion.plotArea
                         x: '08-05-2021 07:00 PM',
                         y: 24.919
                         ),
];
List<CartesianChartAnnotation> returnAnnotations(int index, DeviceData theDeviceData){
List<CartesianChartAnnotation> annotations = [];
 theDeviceData.TempList[index].forEach((element) {
        if(element['anomaly'] == true) {
         annotations.add(CartesianChartAnnotation( 
                        widget: Container(
                        child: Text("1", style: TextStyle(color: Colors.red)),
                         // margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                         )),
                         coordinateUnit: CoordinateUnit.point,
                        // region: AnnotationRegion.plotArea
                         x: returnDate(element['timestamp']),
                         y: element['value'].toDouble()
                         ));
        }}); 

return annotations;
}
Widget testWidget(String type, String unit, String value, int date, List<double>charts, int indexnum, List<_DataPoints> graph, DeviceData theDeviceData, int indexfromList){
  return _buildTile(
              indexnum,
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
                          Text(returnDate(date),
                                  style: TextStyle(color: Colors.blueAccent)
                                  
                                  ) 
                        ],
                      ),
                    

                      //Padding(padding: EdgeInsets.only(bottom: 10, top: 3.0)),
                      SizedBox(
                        width: 800, height: 300,
                        child:
                       SfCartesianChart(
                        annotations: returnAnnotations(indexfromList, theDeviceData),
                        
                        primaryXAxis: CategoryAxis(
                          
                        ),
                        // Chart title
                    
                        borderColor: Colors.indigo,
                        plotAreaBorderWidth: 2,
                        trackballBehavior: TrackballBehavior(
                        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: TrackballLineType.vertical,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y',
        )), 
                     //tooltipBehavior: TooltipBehavior(enable: true),
                    
                        series:
                        <ChartSeries<_DataPoints, String>>[
                        LineSeries<_DataPoints, String>(
                    dataSource: graph,
                    emptyPointSettings: EmptyPointSettings(color: Colors.green),
                    xValueMapper: (_DataPoints sales, _) => sales.time,
                    yValueMapper: (_DataPoints sales, _) => sales.value,
                    name: 'Sales',
                    // Enable data label
                    //dataLabelSettings: DataLabelSettings(isVisible: true),
                    
                    markerSettings: const MarkerSettings(isVisible: true,
                    
                    ),
                   
                    )
              ] 
              ), 
                      ),
                    ],
                  )),
            );
}

Widget testWidget2(String type, String unit, String value, int date, List<double>charts, int indexnum){
  return _buildTile(
             indexnum,
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           Material(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(20.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(IconValues[type],
                                color: Colors.white, size: 25.0),
                          )
                          )
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(SensorNames[type],
                                  style: TextStyle(color: Colors.blueAccent
                      
                                  )
                                  ),
                            
                             Text(readTimestamp(date),
                                  style: TextStyle(color: Colors.blueAccent)
                                  
                                  )         
                            ],
                          ),
                          SizedBox(
                            height: 30,
                            width: 110,
                            child: Sparkline(
                        data: charts,
                        lineWidth: 3.0,
                        lineColor: Colors.lightBlueAccent,
                        ),
                          ),
                          Text(value.toString() + unit.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)), 
                        ],
                      ),
                     // Padding(padding: EdgeInsets.only(bottom: 0, top: 3.0)),
                     /* Sparkline(
                        data: charts,
                        lineWidth: 3.0,
                        lineColor: Colors.green,
                        fillMode: FillMode.below,
                        fillGradient: LinearGradient(colors: [Colors.green, Colors.green[50]], 
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                        ),
                      ) */
                    ],
                  )),
            );
}
Widget testWidget3(String type, String unit, String value, int date, List<double>charts, int indexnum){
  return _buildTile(
              indexnum,
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           Material(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(20.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(IconValues[type],
                                color: Colors.white, size: 30.0),
                          )
                          )
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(type.substring(0,1).toUpperCase() + type.substring(1),
                                  style: TextStyle(color: Colors.blueAccent)
                                  
                                  ),
                              Text(value.toString() + unit.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)),
                             Text(readTimestamp(date),
                                  style: TextStyle(color: Colors.blueAccent)
                                  
                                  )        
                            ],
                          ),
                         Spacer(),
                          SizedBox(
                            height: 30,
                            width: 190,
                            child: Sparkline(
                        data: charts,
                        lineWidth: 3.0,
                        lineColor: Colors.lightBlueAccent,
                        
                        ),
                          ),
                           
                        ],
                      ),
                     // Padding(padding: EdgeInsets.only(bottom: 0, top: 3.0)),
                     /* Sparkline(
                        data: charts,
                        lineWidth: 3.0,
                        lineColor: Colors.green,
                        fillMode: FillMode.below,
                        fillGradient: LinearGradient(colors: [Colors.green, Colors.green[50]], 
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                        ),
                      ) */
                    ],
                  )),
            );
}

Widget CustomDataTab(String type, String unit, String value, int date, List<double>charts, int indexnum, List<_DataPoints> graph, DeviceData theDeviceData, int indexfromList){
  if(tilesize[indexnum] == originaltilesizes[indexnum]){
    return testWidget2(type, unit, value, date, charts, indexnum);
  }
  else return testWidget(type, unit, value, date, charts, indexnum, graph, theDeviceData, indexfromList);
}
String returnDate(int timestamp){
var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
// 12 Hour format:
var d12 = DateFormat('MM-dd-yyyy hh:mm a').format(dt); // 12/31/2000, 10:00 PM
return d12;
}
List<double> returnSparkChart(int index, DeviceData theDeviceData){
  List<double> data = [];
  theDeviceData.TempList[index].forEach((element) {
        data.add(element['value'].toDouble());
       }); 
  return data;
}
List<_DataPoints> returnGraph(int index, DeviceData theDeviceData){
  List<_DataPoints> data = [];
  theDeviceData.TempList[index].forEach((element) {
        data.add(_DataPoints(returnDate(element['timestamp']), element[
                'value'
              ].toDouble()));
       }); 
  return data;
}

 var isButtondisabled = true;
  @override
  Widget build(BuildContext context) {
  CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
  var email = _currentUser.getCurrentUser.email.toString();

  //Stream<DeviceData> mydevicedata = OurDatabase().myDevice(deviceImei, 'HEbxCQEvNHYSmwp9orEW2ViWWA13');
    return Scaffold(
        appBar: MupAppBar(
          'Device Info',
          leadingBackButton: true,
        ),
        body: StreamBuilder<DeviceData>(
          stream: OurDatabase().myDevice('352653090202201', 'HEbxCQEvNHYSmwp9orEW2ViWWA13'),
          builder: (context, snapshot) {
             if(!snapshot.hasData){
           return CircularProgressIndicator(semanticsLabel: "Loading",);
         }
         else{
           DeviceData theDeviceData = snapshot.data;
           int startingTileIndex = 3;
         /*  List<_DataPoints> TempPlot = [];
           List<double> Temperaturedata = [];
            theDeviceData.TempList[0].forEach((element) {
              Temperaturedata.add(element['value']);
              TempPlot.add(_DataPoints(returnDate(element['timestamp']), element[
                'value'
              ]));
            }); */
            List<double> Humiditydata = [];
             theDeviceData.TempList[1].forEach((element) {
              Humiditydata.add(element['value']);
            }); 
            List<double> iaqdata = [];
             theDeviceData.TempList[2].forEach((element) {
              iaqdata.add(element['value']);
            }); 
           // double num1 = theDeviceData.TempList[5][0]['value'].toDouble();
            //print(num1);
           // print(theDeviceData.TempList[5][0]['value'].runtimeType);
          
          return StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              children: <Widget>[
                _buildPrelimTile(
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
                        markers: _createMarker(theDeviceData.lat, theDeviceData.lon),
                        initialCameraPosition: CameraPosition(
                          target: LatLng(theDeviceData.lat, theDeviceData.lon),
                          zoom: 9.0,
                        ),
                      ),
                    ),
                  ),
                )
                ),
                _buildPrelimTile(
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Row(
                              
                               children: [
                                 Tooltip(message:"This shows your report data",
                                   child: Text("Report",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.0)),
                                 ),
                               VerticalDivider(width:35),
                                Material(
                                  child: 
                                  Row(
                                    children: [
                                          SignalStrengthIndicator.bars(
                                        value: theDeviceData.signalStrength,
                                        minValue: -110,
                                        maxValue: 0,
                                        levels: <num, Color>{
                                          -60: Colors.red,
                                          50: Colors.yellow,
                                          75: Colors.green,
                                        },
                                        size: 20,
                                        barCount: 5,
                                        spacing: 0.2,
                                        activeColor: Colors.lightBlue,
                                        ),     
                                Text(theDeviceData.signalratvalue.toString().toUpperCase(), style: TextStyle(color: Colors.black45, fontSize: 15.0)),
                                Tooltip(message: "Notifies power status of your device",
                                  child: Transform.rotate(
                                  angle: 1.57,
                                  child:
                                     Icon(
                                    BatteryConnected[theDeviceData.battery],
                                      size: 20,
                                    ),
                                    ),
                                ),
                                    ],
                                  )
                                )
                               ],
                             
                           ),
                         //provisioning, name, time last seen, synced
                          Divider(),
                          Row(children: [
                                 Text("Name ", style: TextStyle(fontWeight: FontWeight.w500)),
                                 Text(theDeviceData.name.toString(), style: TextStyle(color: Colors.black45)),
                              ],
                           ),
                          Divider(),
                          Row(children: [
                                 Text("Status ", style: TextStyle(fontWeight: FontWeight.w500)),
                                 Text(theDeviceData.provisioningStatus.toString().toLowerCase(), style: TextStyle(color: Colors.black45)),
                              ],
                           ), 
                          Divider(),
                          Row(children: [
                                 Text("Synced ", style: TextStyle(fontWeight: FontWeight.w500)),
                                 Text(theDeviceData.synced.toString().toLowerCase(), style: TextStyle(color: Colors.black45)),
                              ],
                           ), 
                          Divider(),
                          Row(
                          children :[
                          Text("Last Seen ", style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(GetTimeAgo.parse(DateTime.now().subtract(Duration(milliseconds: theDeviceData.timeSinceLastSeen))),
                          softWrap: false,
                          overflow: TextOverflow.clip,
                           style: TextStyle(color: Colors.black45, fontSize:12 )),
                          ]
                          ),
                          
                              
                          
                           
                          
                        //  Padding(padding: EdgeInsets.only(bottom: 16.0)),
                        //  Text(theDeviceData.signalStrength.abs().toString(), style: TextStyle(fontWeight: FontWeight.w500)),
                        ]),
                  ),
                ),
               _buildPrelimTile(
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          Badge(
                            
                            showBadge: true,
                            badgeContent:  Text("1", style: TextStyle(fontSize: 20,
                            color: Colors.white,
                            )),
                              child:
                             Material(
                                  color: Colors.amber,
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: IconButton(
                                      
                                      onPressed:isButtondisabled? null:
                                      () {
                                        showDialog(context: context, builder: 
                                         (BuildContext context) =>  BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child:  AlertDialog(
      title: new Text('Alert Dialog'),
      content: new Text('Alert Dialog Description'),
      actions: <Widget>[
        new TextButton(
          child: new Text("Continue"),
           onPressed: () {
           
          },
        ),
        new TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      ))
                                        ); 
                                        
                                      },
                                      icon: Icon(Icons.notifications,
                                        color: Colors.white, size: 30.0),
                                  ))),
                          ),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                             Text('Alerts',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)),
                            
                           // Text('All ', style: TextStyle(color: Colors.black45)),
                          ]),
                    ),
                  ),
                
                
             // CustomDataTab(theDeviceData.DatapointList[0]['type'].toString(), theDeviceData.DatapointList[0]['unit'].toString(), theDeviceData.DatapointList[0]['value'].round().toString(), theDeviceData.DatapointList[0]['timestamp'], returnSparkChart(0, theDeviceData),3, returnGraph(0, theDeviceData)),
               // testWidget(theDeviceData.DatapointList[1]['type'].toString(), theDeviceData.DatapointList[1]['unit'].toString(), theDeviceData.DatapointList[1]['value'].round().toString(), theDeviceData.DatapointList[1]['timestamp'], Humiditydata,4, returnGraph(0, theDeviceData)),
              //  testWidget2(theDeviceData.DatapointList[3]['type'].toString(), theDeviceData.DatapointList[3]['unit'].toString(), theDeviceData.DatapointList[3]['value'].round().toString(), theDeviceData.DatapointList[3]['timestamp'], iaqdata,4),
              /* _buildDataTab(theDeviceData.DatapointList[1]['type'].toString(), theDeviceData.DatapointList[1]['unit'].toString(), theDeviceData.DatapointList[1]['value'].toString(), theDeviceData.DatapointList[1]['timestamp'].toString()),
               _buildDataTab(theDeviceData.DatapointList[2]['type'].toString(), theDeviceData.DatapointList[2]['unit'].toString(), theDeviceData.DatapointList[2]['value'].toString(), theDeviceData.DatapointList[2]['timestamp'].toString()),
               _buildDataTab(theDeviceData.DatapointList[3]['type'].toString(), theDeviceData.DatapointList[3]['unit'].toString(), theDeviceData.DatapointList[3]['value'].toString(), theDeviceData.DatapointList[3]['timestamp'].toString()),
                _buildDataTab(theDeviceData.DatapointList[4]['type'].toString(), theDeviceData.DatapointList[4]['unit'].toString(), theDeviceData.DatapointList[4]['value'].toString(), theDeviceData.DatapointList[4]['timestamp'].toString()),
              Visibility(child:_buildDataTab(theDeviceData.DatapointList[5]['type'].toString(), theDeviceData.DatapointList[5]['unit'].toString(), theDeviceData.DatapointList[5]['value'].toString(), theDeviceData.DatapointList[5]['timestamp'].toString())
               , visible: false,) */
               for (var i = 0; i < 6; i++) CustomDataTab(theDeviceData.DatapointList[i]['type'].toString(), theDeviceData.DatapointList[i]['unit'].toString(), theDeviceData.DatapointList[i]['value'].round().toString(), theDeviceData.DatapointList[i]['timestamp'], returnSparkChart(i, theDeviceData),startingTileIndex + i, returnGraph(i, theDeviceData), theDeviceData, i),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, tilesize[0]),
                StaggeredTile.extent(1, tilesize[1]),
                StaggeredTile.extent(1, tilesize[2]),
                
                StaggeredTile.extent(2,tilesize[3]),
                StaggeredTile.extent(2,tilesize[4]),
                StaggeredTile.extent(2,tilesize[5]),
                StaggeredTile.extent(2,tilesize[6]),
                StaggeredTile.extent(2,tilesize[7]),
                StaggeredTile.extent(2,tilesize[8]),
               
              ],
            );
         }
          }
        ));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _DataPoints{
  _DataPoints(this.time, this.value);
  final String time;
  final double value;
}