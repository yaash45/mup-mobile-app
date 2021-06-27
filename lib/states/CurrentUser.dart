import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mup_app/backend/database.dart';
import 'package:mup_app/models/UserModel.dart';
import 'package:mup_app/pages/root.dart';



class CurrentUser extends ChangeNotifier{

UserModel _currentUser = UserModel();
/*
String _uid;
String _email; */


UserModel get getCurrentUser => _currentUser;



FirebaseAuth _auth = FirebaseAuth.instance;

//Stream<User> get onAuthStateChanged => _auth.authStateChanges();



Future<String> onStartUp() async {
String retVal = 'error';
String signIn = "SignedIn";
FirebaseAuth.instance
  .idTokenChanges()
  .listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
      signIn = "SignedOut";
    } else {
      print('User is signed in!');
      signIn = 'SignedIn';
    }
  });

  try{
    if(signIn == 'SignedIn'){
   /* _currentUser.uid = _auth.currentUser.uid;
    _currentUser.email = _auth.currentUser.email;
    print(_currentUser.uid);
    print(_currentUser.email);
    retVal = 'success';git 
    print(retVal); */
    _currentUser = await OurDatabase().getUserInfo(_auth.currentUser.uid);
    if (_currentUser != null) {
      print("UID is " + _currentUser.uid);
      print("email is " + _currentUser.email);
      retVal = 'success';
    }

    }
  } catch(e){
    print(e);
  }
   print(retVal);
  return retVal;
}

Future<String> signUpUser(String email, String password, String fullName) async {
 String retVal = 'error';
 UserModel _user = UserModel();
 try{
  UserCredential _authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  _user.uid = _authResult.user.uid;
  _user.email = _authResult.user.email;
  _user.fullName = fullName;
  String _createDBresult = await OurDatabase().createUser(_user);
  if(_createDBresult == 'success') {
   retVal = 'success';
  } 
 }
 catch(e){
  retVal = e.message;
  print(e);
 }

 return retVal;

}

Future<String> loginUser(String email, String password) async {
  String retVal = 'error';
 try{
  UserCredential _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
   
/*   _currentUser.uid = _authResult.user.uid;
    _currentUser.email = _authResult.user.email;
    retVal = 'success'; */
 _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);
 if (_currentUser != null) {
   retVal = 'success';
 }

 }
 catch(e){
  retVal = e.message;
  print(e);
 }

 return retVal;
}

Future<String> loginUserWithGoogle() async {
  String retVal = 'error';
  GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
 UserModel _user = UserModel(); 
 try{
  GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
  
  AuthCredential _credential = GoogleAuthProvider.credential(
    idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken
  );
    
 UserCredential _authResult = await _auth.signInWithCredential(_credential);
 if(_authResult.additionalUserInfo.isNewUser){
  _user.uid = _authResult.user.uid;
  _user.email = _authResult.user.email;
  _user.fullName = _authResult.user.displayName;
  OurDatabase().createUser(_user);
 }
 // _currentUser.uid = _authResult.user.uid;
 // _currentUser.email = _authResult.user.email;
 //   retVal = 'success';

 _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);
 if (_currentUser != null) {
   retVal = 'success';
 }
 }
 catch(e){
  retVal = e.message;
  print(e);
 }

 return retVal;
}

} 