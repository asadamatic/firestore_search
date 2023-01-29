import 'package:flutter/material.dart';

class SearchFiled extends StatelessWidget {
  final bool? showSearchIcon;
  final bool? isSearching;
  final Color? searchBackgroundColor;
  final Color? searchTextHintColor;
  final Color? clearSearchButtonColor;
  final Color? searchTextColor;
  final FocusNode? searchFocusNode;
  final Function()? onClearButtonPressed;
  final Function(String)? onSearchQueryChanged;
  final Function(String)? onSearchQueryUpdated;
  final Function(String)? onEditingComplete;
  final TextCapitalization? textCapitalization;
  final TextInputType? keyboardType;
  TextEditingController? searchQueryController;
  SearchFiled(
      {this.showSearchIcon = false,
      this.isSearching = false,
      this.searchBackgroundColor,
      this.searchTextColor,
      this.searchTextHintColor,
      this.clearSearchButtonColor,
      this.searchFocusNode,
      this.searchQueryController,
      this.onClearButtonPressed,
      this.onSearchQueryChanged,
      this.onSearchQueryUpdated,
      this.onEditingComplete,
        this.textCapitalization,
        this.keyboardType,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40.0,
      margin: showSearchIcon!
          ? const EdgeInsets.only(bottom: 3.5, top: 3.5, right: 2.0, left: 2.0)
          : isSearching!
              ? const EdgeInsets.only(bottom: 3.5, top: 3.5, right: 10.0)
              : const EdgeInsets.only(
                  bottom: 3.5, top: 3.5, right: 10.0, left: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: searchBackgroundColor ?? Colors.blueGrey.withOpacity(.2),
      ),
      child: TextField(
        textCapitalization: textCapitalization!,
        keyboardType: keyboardType!,
        controller: searchQueryController,
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          hintText: "Search...",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: TextStyle(color: searchTextHintColor),
          suffixIcon: searchQueryController!.text.isNotEmpty
              ? IconButton(
                  alignment: Alignment.centerRight,
                  color: clearSearchButtonColor,
                  icon: const Icon(Icons.clear),
                  onPressed: onClearButtonPressed!,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
        ),
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        style: TextStyle(color: searchTextColor, fontSize: 16.0),
        onChanged: (query) => onSearchQueryChanged!(query),
        // onSubmitted: (query) => onSearchQueryUpdated!(query),
        // onEditingComplete: () => onEditingComplete!,
      ),
    );
  }
}
