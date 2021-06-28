import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mup_app/models/UserModel.dart';

class OurDatabase{
  final databaseReference = FirebaseFirestore.instance;

Future<String> createUser(UserModel user) async{
 String retVal = 'error';
 try{
   await databaseReference.collection("users").doc(user.uid).set(
     {
       'fullName' : user.fullName,
       'email'  : user.email,
       'accountCreated' : Timestamp.now(),
     });
   retVal = 'success';

 }
 catch(e){
   print(e);
 }

 return retVal;
}

Future<UserModel> getUserInfo(String uid) async {
UserModel retVal = UserModel();
try {
  DocumentSnapshot _docSnapshot = await databaseReference.collection('users').doc(uid).get();
  retVal.uid = uid;
  retVal.fullName = _docSnapshot.get("fullName");
  retVal.email = _docSnapshot.get("email");
  retVal.accountCreated = _docSnapshot.get("accountCreated");
}
catch(e) {
print(e);
}

return retVal;
}

}