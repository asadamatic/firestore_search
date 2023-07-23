import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:firestore_search/src/mvc/controllers/firestore_search_controller.dart';
import 'package:firestore_search/src/mvc/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirestoreSearchResults extends StatelessWidget {
  final String? docId;
  final String? subCollectionName;

  /// Color for background of results body
  ///
  final Color? resultsBodyBackgroundColor;

  /// Name of the cloud_firestore collection you
  ///
  /// want to search data from
  final String? firestoreCollectionName;

  /// The [searchQuery] is matched against this key value in the firestore document
  ///
  final String? searchBy;

  /// Limit of firestore documents return is search results
  ///
  final int limitOfRetrievedData;

  /// Function that converts [QuerySnapshot] to a list of data model as required
  ///
  final List Function(QuerySnapshot) dataListFromSnapshot;

  /// When search text field is empty, this widget is displayed
  ///
  final Widget? initialBody;

  /// Refers to the [builder] parameter of StreamBuilder used to
  ///
  /// retrieve search results from cloud_firestore
  ///
  /// Use this function display the search results retrieved from cloud_firestore
  ///
  final Widget Function(BuildContext, AsyncSnapshot)? builder;

  /// Unique identifier for [FirestoreSearchController] used by [FirestoreSearchBar] and [FirestoreSearchResults] to enable data sharing
  ///
  final String? tag;

  /// Returns the results from firestore and displays the data using [builder] function provided by the developer
  /// This widget can be used anywhere is the widget tree, and the results will correspond the [searchQuery] of [FirestoreSearchBar] linked by [tag] parameter
  ///
  const FirestoreSearchResults.builder(
      {required this.tag,
      required this.firestoreCollectionName,
      required this.searchBy,
      this.limitOfRetrievedData = 10,
      required this.dataListFromSnapshot,
      this.builder,
      this.docId,
      this.subCollectionName,
      this.initialBody,
      this.resultsBodyBackgroundColor = Colors.white,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirestoreSearchController>(
        tag: tag,
        builder: (_controller) {
          return Stack(
            children: [
              initialBody ?? SizedBox(),
              _controller.searchQuery.isEmpty
                  ? SizedBox()
                  : Container(
                      color: resultsBodyBackgroundColor,
                      child: StreamBuilder<List>(
                          stream: FirestoreService(
                                  docId: docId,
                                  subCollectionName: subCollectionName,
                                  collectionName: firestoreCollectionName,
                                  searchBy: searchBy ?? '',
                                  dataListFromSnapshot: dataListFromSnapshot,
                                  limitOfRetrievedData: limitOfRetrievedData)
                              .searchData(_controller.searchQuery.value),
                          builder: builder!),
                    )
            ],
          );
        });
  }
}
