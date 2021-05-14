import 'package:flutter/material.dart';

class FrequencyProfilePage extends StatefulWidget {
  @override
  _FrequencyProfilePageState createState() => _FrequencyProfilePageState();
}

enum FrequencyProfiles {
  high,
  medium,
  low,
  custom,
}

class _FrequencyProfilePageState extends State<FrequencyProfilePage> {
  int _value = FrequencyProfiles.high.index;
  bool _custom = false;
  int _customValue = 0;

  final customFieldHolder = new TextEditingController();

  void _setCustomValue(customValue) {
    _customValue = customValue;
  }

  void _setFrequencyProfile() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Frequency Profile"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Select Profile:',
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      DropdownButton(
                        value: _value,
                        items: [
                          DropdownMenuItem(
                              child: Text('High'),
                              value: FrequencyProfiles.high.index),
                          DropdownMenuItem(
                              child: Text('Medium'),
                              value: FrequencyProfiles.medium.index),
                          DropdownMenuItem(
                              child: Text('Low'),
                              value: FrequencyProfiles.low.index),
                          DropdownMenuItem(
                              child: Text('Custom'),
                              value: FrequencyProfiles.custom.index),
                        ],
                        onChanged: (value) => {
                          setState(() {
                            _value = value;
                            if (_value == FrequencyProfiles.custom.index) {
                              _custom = true;
                            } else {
                              _custom = false;
                            }
                          })
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      _custom
                          ? TextField(
                              decoration: InputDecoration(
                                labelText: "Custom message frequency",
                                hintText: "1-50",
                                suffixText: "Messages/Hour",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: const BorderSide(
                                //       color: Colors.blue, width: 2.0),
                                //   borderRadius: BorderRadius.circular(12.0),
                                // ),
                              ),
                              keyboardType: TextInputType.number,
                              controller: customFieldHolder,
                              onChanged: _setCustomValue,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text('Selected Message Frequency:'),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('10'),
                                      Text('Messages/Hour')
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                  ),
                                  Text('Estimated bill (\$/month):'),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('10'),
                                      Text('Messages/Hour')
                                    ],
                                  ),
                                ]),
                      Padding(padding: EdgeInsets.all(10.0)),
                    ],
                  )),
              ElevatedButton(
                  onPressed: _setFrequencyProfile, child: Text('Set Profile'))
            ],
          ),
        ));
  }
}
