library firestore_search;

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final String? collectionName;
  final String? searchBy;
  final List Function(QuerySnapshot)? dataListFromSnapshot;
  final int? limitOfRetrievedData;
  final String? docId;
  final String? subCollectionName;

  FirestoreService(
      {this.collectionName,
      this.searchBy,
      this.dataListFromSnapshot,
      this.docId,
      this.subCollectionName,
      this.limitOfRetrievedData});
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List> searchData(String query) {
    final collectionReference = (docId != null && subCollectionName != null)
        ? firebaseFirestore
            .collection(collectionName!)
            .doc(docId)
            .collection(subCollectionName!)
        : firebaseFirestore.collection(collectionName!);
    return query.isEmpty
        ? Stream.empty()
        : collectionReference
            .orderBy('$searchBy', descending: false)
            .where('$searchBy', isGreaterThanOrEqualTo: query)
            .where('$searchBy', isLessThan: query + 'z')
            .limit(limitOfRetrievedData!)
            .snapshots()
            .map(dataListFromSnapshot!);
  }
}
