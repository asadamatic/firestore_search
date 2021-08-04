import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirestoreSearchScaffold extends StatefulWidget {
  /// Creates a scaffold with a search AppBar and integrated cloud_firestore search.
  ///
  /// You can set the scaffold body using the [scaffoldBody] widget
  ///
  /// You can add a bottom widget to search AppBar using the [appBarBottom] widget
  ///
  /// [firestoreCollectionName] , [dataListFromSnapshot] are required

  final Widget scaffoldBody;

  final PreferredSizeWidget? appBarBottom;
  final Color? appBarBackgroundColor,
      backButtonColor,
      clearSearchButtonColor,
      searchBackgroundColor,
      searchTextColor,
      searchTextHintColor,
      scaffoldBackgroundColor,
      searchBodyBackgroundColor,
      appBarTitleColor,
      searchIconColor;

  final bool showSearchIcon;
  final String? firestoreCollectionName, searchBy, appBarTitle;
  final List Function(QuerySnapshot) dataListFromSnapshot;
  final Widget Function(BuildContext, AsyncSnapshot)? builder;
  final int limitOfRetrievedData;

  const FirestoreSearchScaffold({
    this.appBarBottom,
    this.scaffoldBody = const Center(child: Text('Add a scaffold body')),
    this.appBarBackgroundColor,
    this.backButtonColor,
    this.clearSearchButtonColor,
    this.searchBackgroundColor,
    this.searchTextColor,
    this.searchTextHintColor,
    this.scaffoldBackgroundColor,
    this.searchBodyBackgroundColor,
    this.showSearchIcon = false,
    this.searchIconColor,
    this.appBarTitle,
    this.appBarTitleColor,

    /// Name of the cloud_firestore collection you
    /// want to search data from
    required String this.firestoreCollectionName,
    required this.searchBy,

    /// This function takes QuerySnapshot as an argument an returns the object of your dataMode
    /// See example of such a function here
    required this.dataListFromSnapshot,

    /// Refers to the [builder] parameter of StreamBuilder used to
    /// retrieve search results from cloud_firestore
    /// Use this function display the search results retrieved from cloud_firestore
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
                        ? searchField()
                        : Container(
                            margin: const EdgeInsets.only(left: 14.0),
                            child: Text(
                              widget.appBarTitle ?? 'AppBar Title',
                              style: TextStyle(color: widget.appBarTitleColor),
                            ))
                    : searchField(),
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
                child: StreamBuilder<List>(
                    stream: FirestoreServicePackage(
                            collectionName: widget.firestoreCollectionName,
                            searchBy: widget.searchBy ?? '',
                            dataListFromSnapshot: widget.dataListFromSnapshot,
                            limitOfRetrievedData: widget.limitOfRetrievedData)
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

  Widget searchField() {
    return Container(
      alignment: Alignment.center,
      height: 40.0,
      margin: widget.showSearchIcon
          ? const EdgeInsets.only(bottom: 3.5, top: 3.5, right: 2.0, left: 2.0)
          : isSearching
              ? const EdgeInsets.only(bottom: 3.5, top: 3.5, right: 10.0)
              : const EdgeInsets.only(
                  bottom: 3.5, top: 3.5, right: 10.0, left: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: widget.searchBackgroundColor ?? Colors.blueGrey.withOpacity(.2),
      ),
      child: TextField(
        controller: searchQueryController,
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          hintText: "Search...",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: TextStyle(color: widget.searchTextHintColor),
          suffixIcon: searchQueryController.text.isNotEmpty
              ? IconButton(
                  alignment: Alignment.centerRight,
                  color: widget.clearSearchButtonColor,
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearchQuery,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
        ),
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        style: TextStyle(color: widget.searchTextColor, fontSize: 16.0),
        onChanged: (query) => updateSearchQuery(query),
      ),
    );
  }
}
