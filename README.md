# Firestore Search Scaffold - firestore_search

This package helps developers in implementation of search on Cloud FireStore. This package comes with the implementation of widgets essential  for  performing search on a database.
### Make sure to use `firestore_core` in your project
### **Depends on `cloud_firestore: ^2.2.2`**



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


## Implementation:

* Import `import 'package:firestore_search/firestore_search.dart';`

* Create a data model, for the data you want retrieve from Cloud FireStore _(Your data model class must contain a function to convert QuerySnapshot from Cloud Firestore to a list of objects of your data model)_

```
class DataModel {
  final String? name;
  final String? developer;
  final String? framework;
  final String? tool;

  DataModel({this.name, this.developer, this.framework, this.tool});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return DataModel(
          name: dataMap['name'],
          developer: dataMap['developer'],
          framework: dataMap['framework'],
          tool: dataMap['tool']);
    }).toList();
  }
}
```

* Use class `FirestoreSearchScaffold` and provide the required parameters

```
FirestoreSearchScaffold(
      firestoreCollectionName: 'packages',
      searchBy: 'tool',
      scaffoldBody: const Center(child: Text('Firestore Search')),
      dataListFromSnapshot: DataModel().dataListFromSnapshot,
      builder: (context, snapshot) {

          if (snapshot.hasData) {
            final List<DataModel>? dataList = snapshot.data;

            return ListView.builder(
                itemCount: dataList?.length ?? 0,
                itemBuilder: (context, index) {
                  final DataModel data = dataList![index];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${data.name}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, right: 8.0),
                        child: Text('${data.developer}',
                            style: Theme.of(context).textTheme.bodyText1),
                      )
                    ],
                  );
                });
          }


          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData){
              return const Center(child: Text('No Results Returned'),);
            }
          }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
```

                                                                                       
## <div align="center">You are good to go 💯</div>

---





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
