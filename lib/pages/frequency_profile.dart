import 'package:flutter/material.dart';

class FrequencyProfilePage extends StatefulWidget {
  @override
  _FrequencyProfilePageState createState() => _FrequencyProfilePageState();
}

const int HighFrequencyProfileValue = 30;
const int MediumFrequencyProfileValue = 20;
const int LowFrequencyProfileValue = 10;

// This is just a default value for the custom profile,
// separate from the message frequency
const int CustomFrequencyProfileValue = 0;

class _FrequencyProfilePageState extends State<FrequencyProfilePage> {
  int _value = HighFrequencyProfileValue;
  bool _custom = false;

  // Initially, always start by setting the message frequency for the high profile
  int _messageFrequency = HighFrequencyProfileValue;

  final customFieldHolder = new TextEditingController();

  void _setValue(String customValue) {
    _messageFrequency = int.parse(customValue);
    setState(() {});
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
                            _custom = _value == CustomFrequencyProfileValue;

                            if (!_custom) {
                              _messageFrequency = _value;
                            }
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      _custom
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TODO: Need to come up with a maximum value for custom
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "Custom message frequency",
                                    hintText: "Please enter a number",
                                    suffixText: "Messages/Hour",
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 2.0),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: customFieldHolder,
                                  onChanged: _setValue,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 40.0),
                                ),
                                BillingInformation(
                                    messageFrequency: _messageFrequency),
                              ],
                            )
                          : BillingInformation(
                              messageFrequency: _messageFrequency),
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
          Text('${(widget.messageFrequency * 0.55).toStringAsFixed(2)} \$/hour')
        ],
      ),
    ]);
  }
}
