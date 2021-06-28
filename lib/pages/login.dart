import 'package:flutter/material.dart';
import 'package:mup_app/backend/flutterfire.dart';
import 'package:mup_app/templates/colors.dart';
import 'package:mup_app/pages/sign_up.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

enum LoginType {
  email,
  google,
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  void _loginUser(String email, String password, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    try {
      String _returnString = await _currentUser.loginUser(email, password);
      if (_returnString == 'success') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyHomePage(title: "myapp"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void _loginUserWithGoogle(BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.loginUserWithGoogle();
    try {
      if (_returnString == 'success') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyHomePage(title: "myapp"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Widget google_sign_up2(context) {
    return InkWell(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 0),
        child: Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: MupColors.appSwatch.shade100),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/google_logo.png'),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ],
            ))),
      ),
      onTap: () async {
        _loginUserWithGoogle(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset(
                      'MUP.png',
                      fit: BoxFit.fitWidth,
                      height: 100,
                      width: 200,
                    )),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _emailField,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'abc@gmail.com'),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _passwordField,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: MupColors.mainTheme,
                    borderRadius: BorderRadius.circular(50)),
                child: TextButton(
                  onPressed: () async {
                    _loginUser(_emailField.text, _passwordField.text, context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            google_sign_up2(context),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: Text(
                  'Create Account',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// google_sign_up not used - may need later for UI purposes
Widget google_sign_up() {
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/weddinglogo.png'),
            ),
          ),
        ),
        Container(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 15, left: 10, right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                          //  width: deviceSize
                          //      .width/2,
                          //  height: deviceSize.height/18,
                          margin: EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/google.jpg'),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                'Sign in with Google',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ))),
                      onTap: () async {},
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
