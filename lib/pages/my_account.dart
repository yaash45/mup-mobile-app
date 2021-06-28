//import 'package:beautiful_list/model/lesson.dart';
import 'package:flutter/material.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:mup_app/templates/appbar.dart';
import 'package:mup_app/templates/colors.dart';
import 'package:provider/provider.dart';

//import 'package:beautiful_list/detail_page.dart';
class MyAccount extends StatefulWidget {
  MyAccount({Key key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    var _currentUser = Provider.of<CurrentUser>(context, listen: false);

    ListTile makeListTile(String title, String value) => ListTile(
          leading: SizedBox(
            width: 90,
            child: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: //Icon(Icons.account_box, color: Colors.white),
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          title: Text(
            value,
            style:
                TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w400),
          ),
        );

    Card makeCard(String title, String value) => Card(
        elevation: 2,
        shadowColor: MupColors.shadowColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5, color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [makeListTile(title, value)],
        ));

    final makeBody = ListView(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      physics: NeverScrollableScrollPhysics(),
      children: [
        makeCard("Full Name", _currentUser.fullName),
        makeCard("Email", _currentUser.email),
        makeCard("Account created", _currentUser.accountCreated),
      ],
    );

    final topAppBar = MupAppBar('My Account');

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
    );
  }
}
