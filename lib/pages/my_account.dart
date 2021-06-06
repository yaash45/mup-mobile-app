//import 'package:beautiful_list/model/lesson.dart';
import 'package:flutter/material.dart';
//import 'package:beautiful_list/detail_page.dart';

class MyAccount extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
     // theme: new ThemeData(
        //  primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'Raleway'),
      home: new MyAccount2(title: 'Account'),
      // home: DetailPage(),
    );
  }
}



class MyAccount2 extends StatefulWidget {
  MyAccount2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAccount2State createState() => _MyAccount2State();
}

class _MyAccount2State extends State<MyAccount2> {
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
            Text("Username",
            style:TextStyle(fontWeight: FontWeight.bold)),
          ),
          title: Text(
           "John Doe",
            style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w300),
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
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(28, 124, 219, 1),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 0.2),
      appBar: topAppBar,
      body: makeBody,
    //  bottomNavigationBar: makeBottom,
    );
  }
}


