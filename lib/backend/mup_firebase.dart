import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = FirebaseFirestore.instance;

Future<DocumentReference> insertObjectToFirestore(
        String collectionName, Map<String, dynamic> data) =>
    databaseReference.collection(collectionName).add(data);
