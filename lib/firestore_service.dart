import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServicePackage<T> {
  final String collectionName;
  final List Function(QuerySnapshot) dataListFromSnapshot;
  final int limitOfRetrievedData;

  FirestoreServicePackage(
      {this.collectionName,
      this.dataListFromSnapshot,
      this.limitOfRetrievedData});
  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  Stream<List> searchData(String query) {
    final collectionReference = firebasefirestore.collection(collectionName);

    return collectionReference
        .where('username', isGreaterThanOrEqualTo: query ?? '')
        .limit(limitOfRetrievedData)
        .snapshots()
        .map(dataListFromSnapshot);
  }
}
