import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  Timestamp accountCreated;
  String fullName;
  //Notif
  //Devicelist
  

  UserModel({
    this.uid,
    this.email,
    this.accountCreated,
    this.fullName,
  });

 
}