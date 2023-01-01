import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/src/mvc/controllers/firestore_search_controller.dart';
import 'package:firestore_search/src/mvc/services/firestore_service.dart';
import 'package:firestore_search/src/mvc/widgets/search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
export 'package:firestore_search/src/mvc/controllers/firestore_search_controller.dart'
    hide FirestoreSearchController;
export 'package:firestore_search/src/mvc/views/search_bar.dart'
    show FirestoreSearchBar;
export 'package:firestore_search/src/mvc/views/search_results.dart'
    show FirestoreSearchResults;

class FirestoreSearchScaffold extends StatefulWidget {
  final Widget scaffoldBody;

  /// Widget that will be displayed in the bottom of app bar
  ///
  final PreferredSizeWidget? appBarBottom;
  final Color? appBarBackgroundColor;
  final Color? backButtonColor;
  final Color? clearSearchButtonColor;
  final Color? searchBackgroundColor;
  final Color? searchTextColor;
  final Color? searchTextHintColor;
  final Color? scaffoldBackgroundColor;
  final Color? searchBodyBackgroundColor;
  final Color? appBarTitleColor;
  final Color? searchIconColor;
  final Widget? bottomNavigationBar;

  final bool showSearchIcon;

  /// Name of the cloud_firestore collection you
  ///
  /// want to search data from
  final String? firestoreCollectionName;
  final String? searchBy;
  final String? appBarTitle;
  final List Function(QuerySnapshot) dataListFromSnapshot;

  /// Refers to the [builder] parameter of StreamBuilder used to
  ///
  /// retrieve search results from cloud_firestore
  ///
  /// Use this function display the search results retrieved from cloud_firestore
  final Widget Function(BuildContext, AsyncSnapshot)? builder;
  final int limitOfRetrievedData;

  /// Creates a scaffold with a search AppBar and integrated cloud_firestore search.
  ///
  /// You can set the scaffold body using the [scaffoldBody] widget
  ///
  /// You can add a bottom widget to search AppBar using the [appBarBottom] widget
  ///
  /// [firestoreCollectionName] , [dataListFromSnapshot] are required
  const FirestoreSearchScaffold({
    this.appBarBottom,
    this.scaffoldBody = const Center(child: Text('Add a scaffold body')),
    this.appBarBackgroundColor,
    this.backButtonColor,
    this.clearSearchButtonColor,
    this.searchBackgroundColor = Colors.white,
    this.searchBodyBackgroundColor = Colors.white,
    this.searchTextColor,
    this.searchTextHintColor,
    this.scaffoldBackgroundColor,
    this.showSearchIcon = false,
    this.searchIconColor,
    this.appBarTitle,
    this.appBarTitleColor,
    this.bottomNavigationBar,
    required String this.firestoreCollectionName,
    required this.searchBy,
    required this.dataListFromSnapshot,
    this.builder,
    this.limitOfRetrievedData = 10,
  }) : //Firestore parameters assertions
        assert(limitOfRetrievedData >= 1 && limitOfRetrievedData <= 30,
            'limitOfRetrievedData should be between 1 and 30.\n');

  @override
  _FirestoreSearchScaffoldState createState() =>
      _FirestoreSearchScaffoldState();
}

class _FirestoreSearchScaffoldState extends State<FirestoreSearchScaffold> {
  TextEditingController searchQueryController = TextEditingController();
  bool isSearching = false;
  String searchQuery = "";
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus) {
        setState(() {
          isSearching = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: widget.bottomNavigationBar,
        backgroundColor: widget.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: widget.appBarBackgroundColor,
          centerTitle: true,
          titleSpacing: 0.0,
          title: Row(
            children: [
              if (isSearching)
                BackButton(
                  color: widget.backButtonColor,
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchFocusNode.unfocus();
                      clearSearchQuery();
                    });
                  },
                ),
              Expanded(
                child: widget.showSearchIcon
                    ? isSearching
                        ? SearchFiled(
                            searchQueryController: searchQueryController,
                            isSearching: isSearching,
                            showSearchIcon: widget.showSearchIcon,
                            clearSearchButtonColor:
                                widget.clearSearchButtonColor,
                            searchFocusNode: searchFocusNode,
                            searchBackgroundColor: widget.searchBackgroundColor,
                            searchTextColor: widget.searchTextColor,
                            searchTextHintColor: widget.searchTextHintColor,
                            onClearButtonPressed: clearSearchQuery,
                            onSearchQueryChanged: updateSearchQuery,
                          )
                        : Container(
                            margin: const EdgeInsets.only(left: 14.0),
                            child: Text(
                              widget.appBarTitle ?? 'AppBar Title',
                              style: TextStyle(color: widget.appBarTitleColor),
                            ))
                    : SearchFiled(
                        searchQueryController: searchQueryController,
                        isSearching: isSearching,
                        showSearchIcon: widget.showSearchIcon,
                        searchFocusNode: searchFocusNode,
                        clearSearchButtonColor: widget.clearSearchButtonColor,
                        searchBackgroundColor: widget.searchBackgroundColor,
                        searchTextColor: widget.searchTextColor,
                        searchTextHintColor: widget.searchTextHintColor,
                        onClearButtonPressed: clearSearchQuery,
                        onSearchQueryChanged: updateSearchQuery,
                      ),
              ),
              if (widget.showSearchIcon)
                IconButton(
                    icon: const Icon(Icons.search),
                    padding: const EdgeInsets.all(0),
                    color: widget.searchIconColor ??
                        Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        if (!isSearching) {
                          isSearching = true;
                          searchFocusNode.requestFocus();
                        } else {
                          searchFocusNode.unfocus();
                        }
                      });
                    })
            ],
          ),
          bottom: isSearching ? null : widget.appBarBottom,
        ),
        body: Stack(
          children: [
            widget.scaffoldBody,
            if (isSearching)
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: widget.searchBodyBackgroundColor,
                child: searchQuery.isEmpty
                    ? SizedBox()
                    : StreamBuilder<List>(
                        stream: FirestoreService(
                                collectionName: widget.firestoreCollectionName,
                                searchBy: widget.searchBy ?? '',
                                dataListFromSnapshot:
                                    widget.dataListFromSnapshot,
                                limitOfRetrievedData:
                                    widget.limitOfRetrievedData)
                            .searchData(searchQuery),
                        builder: widget.builder!),
              )
          ],
        ));
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void stopSearching() {
    clearSearchQuery();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearchQuery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchQueryController.dispose();
    super.dispose();
  }
}
