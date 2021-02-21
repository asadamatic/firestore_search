# Firestore Search Scaffold - firestore_search

This package helps developers in implementation of search on Cloud FireStore. This package comes with the implementation of widgets essential  for  performing search on a database.

## **For `cloud_firestore: ^0.14.0` use `firestore_search: ^0.1.1`**
<p>
  <img width="216px" alt="Activated Search App BAr" src="https://raw.githubusercontent.com/asadamatic/firestore_search/master/assets/searchbar.gif"/>

  <img width="216px" alt="Searching for Users in Firestore Collection" src="https://raw.githubusercontent.com/asadamatic/firestore_search/master/assets/usersearch.gif"/>
</p>

[![Pub Version](https://img.shields.io/pub/v/firestore_search?logo=flutter&style=for-the-badge)](https://pub.dev/packages/firestore_search)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/asadamatic/firestore_search/pub_publish?logo=github&style=for-the-badge)
[![Github Stars](https://img.shields.io/github/stars/asadamatic/firestore_search?logo=github&style=for-the-badge)](https://github.com/asadamatic/firestore_search)
[![GitHub](https://img.shields.io/github/license/asadamatic/firestore_search?logo=open+source+initiative&style=for-the-badge)](https://github.com/asadamatic/firestore_search/blob/master/LICENSE)
<!-- [![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-FC60A8?logo=awesome-lists&style=for-the-badge)](https://github.com/Solido/awesome-flutter#widgets) -->

### Saves You from following implementations

* **Search AppBar** - An AppBar that turns into a TextInputField that takes search queries from users
* **Search Body** - A body that shoes up when user starts typing in the Search AppBar
* **Cloud FireStore Queries** - Takes user's input and queries the requested CloudFirestore collection


## Simple Usage
To use this plugin, add `firestore_search` as a
[dependency in your pubspec.yaml file](https://pub.dev/packages/firestore_search/install).


##Implementation:

* Import `import 'package:firestore_search/firestore_search.dart';`

* Create a data model, for the data you want retrieve from Cloud FireStore _(Your data model class must contain a function to convert QuerySnapshot from Cloud Firestore to a list of objects of your data model)_

```
class DataModel {
  final String name;
  final String description;

  DataModel({this.name, this.description});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> **dataListFromSnapshot**(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data();

      return DataModel(
          name: dataMap['name'], description: dataMap['description']);
    }).toList();
  }
}
```

* Use class `FirestoreSearchScaffold` and provide the required parameters

```
FirestoreSearchScaffold(
        dataListFromSnapshot: UserData().userListFromSnapshot,
        firestoreCollectionName: 'users',
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text('Snapshot has data'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Snapshot has data'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        ));
```

                                                                                      ##You are good to go!

In order to add the `FirestoreSearchScaffold` in your app, there are several attributes that are important and neglecting them  or treating them roughly might throw errors:

| Attribute | Type  | Default | Required | Description |
|-----------|-------|---------|-------------|----------|
| `scaffoldBody` | `Widget` | `Widget` | `No` | This widget will appear in the body of Scaffold. |
| `appBarBottom` | `PreferredSizeWidget` | `null`  | `No` | This widget will appear at the bottom of Search AppBar. |
| `firestoreCollectionName` | `String` | `` | `Yes` | Determines the Cloud Firestore collection You want to search in. |
| `searchBy` | `String` | `` | `Yes` | Key for the firestore_collection value you want to search by. |
| `dataListFromSnapshot` | `List Function(QuerySnapshot)` | `null` | `Yes` | This function converts QuerySnapshot to A List of required data. |
| `builder` | `Widget Function(BuildContext, AsyncSnapshot)` | `null` | `No` | This is the builder function of StreamBuilder used by this widget to show search results. |
| `limitOfRetrievedData` | `int` | `10` | `No` | Determines the number of documents returned by the search query. |

## CREDITS
### Contributors
<a href="https://github.com/asadamatic/firestore_search/graphs/contributors">
  <img src="https://contributors-img.firebaseapp.com/image?repo=asadamatic/firestore_search" />
</a>

Made with [contributors-img](https://contributors-img.firebaseapp.com).
