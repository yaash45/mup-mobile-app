import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = FirebaseFirestore.instance;

class MupFirestore {
// The insertion function returns a future that needs to be resolved by the caller
  Future<DocumentReference> insertObject(
          String collectionName, Map<String, dynamic> data) =>
      databaseReference.collection(collectionName).add(data);

// The get function returns a future that needs to be resolved by the caller
  Future<QuerySnapshot> getObjectByCollection(String collectionName) =>
      databaseReference.collection(collectionName).get();
}
