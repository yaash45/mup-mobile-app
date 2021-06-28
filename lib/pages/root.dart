import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mup_app/pages/home_page.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  unAuthenticated,
  Authenticated,
}

class OurRoot extends StatefulWidget {
  OurRoot({Key key}) : super(key: key);

  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unAuthenticated;

  @override
    void didChangeDependencies() async {
      // TODO: implement didChangeDependencies
      super.didChangeDependencies();
       print("did change dependencieees");
      //get the state, check the user, set AuthStatus based on state
      CurrentUser _currentuser = Provider.of<CurrentUser>(context, listen: false);
      String _returnString = await _currentuser.onStartUp();

      if (_returnString == 'success') {
        setState(() {
           _authStatus = AuthStatus.Authenticated;  
              });
       

      }



    }

  @override
  Widget build(BuildContext context) {
    Widget retVal;
   
    switch (_authStatus) {
      case  AuthStatus.unAuthenticated:
        retVal = MyApp();
        break;
      case  AuthStatus.Authenticated:
        retVal = MyHomePage(title: "myapp");
        break;
      default:
    }
    return retVal;

  }
}