import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

     body: Container(
     width: MediaQuery.of(context).size.width,
     height: MediaQuery.of(context).size.height,
     decoration: BoxDecoration(
       color: Colors.white,
     ),
     
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       Image(image: AssetImage('../web/icons/MUP.png')),
       TextFormField(
         controller: _emailField,
         decoration: InputDecoration(
           hintText: "email@gmail.com",
           hintStyle: TextStyle(color: Colors.white,
           ),
           labelText: "Email",
           labelStyle: TextStyle(
            //color: Colors.white,
           ),
         ),
       ),
       TextFormField(
         controller: _passwordField,
         obscureText: true,
         decoration: InputDecoration(
           hintText: "Password",
           hintStyle: TextStyle(color: Colors.white,
           ),
           labelText: "Password",
           labelStyle: TextStyle(
          //  color: Colors.white,
           ),
         ),
       ),
       Container(
         width: MediaQuery.of(context).size.width / 1.4,
         height: 45,
         decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
          color: Colors.blue,
         ),
        child: MaterialButton(
          onPressed: () {

          },
          child: Text("Login")
        ),
         

       ),
        Container(
         width: MediaQuery.of(context).size.width / 1.4,
         height: 45,
         decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
          color: Colors.blue,
         ),
        child: MaterialButton(
          onPressed: () {

          },
          child: Text("Create Account")
        ),
         

       ),

     ],
    ),

     ),
    );
  }
}
