import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FirestoreSearchController extends GetxController {
  RxBool isSearching = false.obs;
  RxString searchQuery = "".obs;
  Rx<TextEditingController> searchQueryController = TextEditingController().obs;

  void updateSearchQuery(String newQuery) {
    searchQuery.value = newQuery;
    update();
  }

  void stopSearching() {
    clearSearchQuery();
    isSearching.value = false;
    update();
  }

  void clearSearchQuery() {
    searchQueryController.value.clear();
    updateSearchQuery("");
    update();
  }
}
