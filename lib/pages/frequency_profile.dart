import 'package:flutter/material.dart';
import 'package:mup_app/backend/database.dart';
import 'package:mup_app/models/FrequencyProfile.dart';
import 'package:mup_app/templates/appbar.dart';

class FrequencyProfilePage extends StatefulWidget {
  FrequencyProfilePage({Key key, this.imei, this.deviceName}) : super(key: key);

  final String imei;
  final String deviceName;

  @override
  _FrequencyProfilePageState createState() =>
      _FrequencyProfilePageState(imei, deviceName);
}

const int HighFrequencyProfileValue = 60;
const int MediumFrequencyProfileValue = 30;
const int LowFrequencyProfileValue = 10;

// This is just a default value for the custom profile,
// separate from the message frequency
const int CustomFrequencyProfileValue = 0;

// TODO: Check how to determine this later
const double PricePerMessageInDollars = 0.50;

class _FrequencyProfilePageState extends State<FrequencyProfilePage> {
  final String imei;
  final String deviceName;
  _FrequencyProfilePageState(this.imei, this.deviceName);

  OurDatabase _db = new OurDatabase();
  FrequencyProfile _profile;
  int _value = HighFrequencyProfileValue;
  bool _custom = false;

  // Initially, always start by setting the message frequency for the high profile
  int _messageFrequency = HighFrequencyProfileValue;

  final customFieldHolder = new TextEditingController();

  void _setValue(String customValue) {
    _messageFrequency = int.parse(customValue);
    setState(() {
      _profile.messagesPerHour = _messageFrequency;
      _profile.preset = 'custom';
      _db.pushFrequencyProfileToFirestore(_profile, imei);
    });
  }

  void clearTextInput() {
    customFieldHolder.clear();
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:
            Text("Set Frequency Profile to $_messageFrequency Messages/Hour"),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _setFrequencyProfile() {
    clearTextInput();
    _showToast(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MupAppBar(
          'Frequency Profile',
          leadingBackButton: false,
        ),
        body: StreamBuilder<FrequencyProfile>(
            stream: _db.getFrequencyProfile(imei),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              } else {
                _profile = snapshot.data;

                if (_profile.preset == 'custom') {
                  _value = CustomFrequencyProfileValue;
                  _custom = true;
                } else if (_profile.preset == 'high') {
                  _value = HighFrequencyProfileValue;
                  _custom = false;
                } else if (_profile.preset == 'medium') {
                  _value = MediumFrequencyProfileValue;
                  _custom = false;
                } else if (_profile.preset == 'low') {
                  _value = LowFrequencyProfileValue;
                  _custom = false;
                }

                _messageFrequency = _profile.messagesPerHour;

                return Container(
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
                                      value: HighFrequencyProfileValue),
                                  DropdownMenuItem(
                                      child: Text('Medium'),
                                      value: MediumFrequencyProfileValue),
                                  DropdownMenuItem(
                                      child: Text('Low'),
                                      value: LowFrequencyProfileValue),
                                  DropdownMenuItem(
                                      child: Text('Custom'),
                                      value: CustomFrequencyProfileValue),
                                ],
                                onChanged: (int value) {
                                  setState(() {
                                    _value = value;
                                    _custom =
                                        _value == CustomFrequencyProfileValue;

                                    if (!_custom) {
                                      _messageFrequency = _value;
                                      _profile.messagesPerHour =
                                          _messageFrequency;

                                      if (_value == HighFrequencyProfileValue) {
                                        _profile.preset = 'high';
                                      } else if (_value ==
                                          MediumFrequencyProfileValue) {
                                        _profile.preset = 'medium';
                                      } else if (_value ==
                                          LowFrequencyProfileValue) {
                                        _profile.preset = 'low';
                                      } else {
                                        _profile.preset = 'custom';
                                      }
                                    } else {
                                      _profile.preset = 'custom';
                                    }

                                    _db.pushFrequencyProfileToFirestore(
                                        _profile, imei);
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                              ),
                              _custom
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText:
                                                "Custom message frequency",
                                            hintText: "Please enter a number",
                                            suffixText: "Messages/Hour",
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          controller: customFieldHolder,
                                          onChanged: _setValue,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, 0, 40.0),
                                        ),
                                        BillingInformation(
                                            messageFrequency:
                                                _messageFrequency),
                                      ],
                                    )
                                  : BillingInformation(
                                      messageFrequency: _messageFrequency),
                              Padding(padding: EdgeInsets.all(10.0)),
                            ],
                          )),
                      ElevatedButton(
                          onPressed: _setFrequencyProfile, child: Text('Done'))
                    ],
                  ),
                );
              }
            }));
  }
}

class BillingInformation extends StatefulWidget {
  BillingInformation({Key key, this.messageFrequency}) : super(key: key);

  final int messageFrequency;

  @override
  _BillingInformationState createState() => _BillingInformationState();
}

class _BillingInformationState extends State<BillingInformation> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Selected Message Frequency:'),
      Padding(
        padding: EdgeInsets.all(5.0),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("${widget.messageFrequency} Messages/Hour")],
      ),
      Padding(
        padding: EdgeInsets.all(15.0),
      ),
      Text('Estimated bill:'),
      Padding(
        padding: EdgeInsets.all(5.0),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              '${(widget.messageFrequency * PricePerMessageInDollars).toStringAsFixed(2)} \$/hour')
        ],
      ),
    ]);
  }
}
