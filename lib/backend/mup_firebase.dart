import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = FirebaseFirestore.instance;

// The insertion function returns a future that needs to be resolved by the caller
Future<DocumentReference> insertObjectToFirestore(
        String collectionName, Map<String, dynamic> data) =>
    databaseReference.collection(collectionName).add(data);
