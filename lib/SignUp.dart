import 'package:flutter/material.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _NameController =TextEditingController();
  TextEditingController _emailController =TextEditingController();
  TextEditingController _passwordController =TextEditingController();
  TextEditingController _confirmPasswordController =TextEditingController();

  void _signUpUser(String email, String password, BuildContext context) async{
   CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
   try{
    String _returnString = await _currentUser.signUpUser(email, password);
      if(_returnString == 'success'){
        Navigator.pop(context);
      }
      else {
         ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text(_returnString),
                    backgroundColor: Colors.red,
                    ),
                 );
      }
   }
   catch(e){
     print(e);
   }

  }
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        /*    Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('MUP.png', fit: BoxFit.fitWidth,height: 100,
                width: 200,)),
              ), 
            ), */
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TextFormField(
                controller: _NameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'John Doe'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _emailController,
                obscureText: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Confirm secure password'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () async {
                 if(_passwordController.text == _confirmPasswordController.text){
                   _signUpUser(_emailController.text, _passwordController.text, context);
                 }
                 else {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                    content: Text('Passwords did not match'),
                    backgroundColor: Colors.red,
                    ),
                 );
                 }
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}