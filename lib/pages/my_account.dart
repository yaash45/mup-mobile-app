//import 'package:beautiful_list/model/lesson.dart';
import 'package:flutter/material.dart';

//import 'package:beautiful_list/detail_page.dart';
class MyAccount extends StatefulWidget {
  MyAccount({Key key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  List lessons;

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile() => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.grey))),
            child: //Icon(Icons.account_box, color: Colors.white),
                Text("Username", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          title: Text(
            "John Doe",
            style:
                TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w300),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          /*    subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: 0.33,
                        valueColor: AlwaysStoppedAnimation(Colors.green)),
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("21",
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ), */
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
        );

    Card makeCard() => Card(
          elevation: 15.0,
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: makeListTile(),
          ),
        );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return makeCard();
        },
      ),
    );

    final topAppBar = AppBar(
      title: Text('My Account'),
      leading: Container(),
    );

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
    );
  }
}
