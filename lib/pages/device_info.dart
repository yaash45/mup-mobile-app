import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mup_app/templates/appbar.dart';
//import 'package:permission/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

  static final LatLng _center = LatLng(49.246292, -123.116);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setPermissions() async {
    await Permission.location.serviceStatus.isEnabled;
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
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 11.0,
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
                      Text('IMEI',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                      Text(deviceImei, style: TextStyle(color: Colors.black45)),
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
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 220.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(2, 220.0),
            StaggeredTile.extent(2, 110.0),
          ],
        ));
  }
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
