# Firestore Search Scaffold - firestore_search_input

Live search in Cloud Firestore.

### Make sure to use `firestore_core` in your project
### **Depends on `cloud_firestore: ^4.3.1`**
### **Depends on `get: ^4.6.5`**

<br>

### Saves You from following implementations

* **Search AppBar** - An AppBar that turns into a TextInputField that takes search queries from users
* **Search Body** - A body that shoes up when user starts typing in the Search AppBar
* **Cloud FireStore Queries** - Takes user's input and queries the requested CloudFirestore collection

* **This package is an upgraded copy of the** - firestore_search
* **Thanks to** - Asad Hameed


## Simple Usage
To use this plugin, add `firestore_search` as a
[dependency in your pubspec.yaml file](https://pub.dev/packages/firestore_search/install).


## Implementation:

* Import `import 'package:firestore_search/firestore_search.dart';`

* Create a data model, for the data you want retrieve from Cloud FireStore _(Your data model class must contain a function to convert QuerySnapshot from Cloud Firestore to a list of objects of your data model)_

```dart
class Book {
  final String? name;
  final String? developer;
  final String? framework;
  final String? tool;

  Book({this.name, this.developer, this.framework, this.tool});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this Book
  //This function in essential to the working of FirestoreSearchScaffold

  List<Book> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return Book(
          name: dataMap['name'],
          developer: dataMap['developer'],
          framework: dataMap['framework'],
          tool: dataMap['tool']);
    }).toList();
  }
}
```

* Use class `FirestoreSearchScaffold` and provide the required parameters

```dart
  Expanded(
    child: FirestoreSearchScaffold(
      textCapitalization: TextCapitalization.characters,
      // keyboardType: TextInputType.text,
      backButtonColor: Colors.blue,
      firestoreCollectionName: 'books',
      searchBy: 'title',
      scaffoldBody: Center(),
      dataListFromSnapshot: Book().dataListFromSnapshot,

      builder: (context, snapshot) {
        print(snapshot.error);

        if (snapshot.hasData) {
          final List<Book>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final Book data = dataList[index];

                return InkWell(
                  onTap: (){
                    print('searched id ${data.id}');
                    Navigator.pop(context, '${data.id}');
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, right: 8.0),
                        child: Text(data.author,
                            style: Theme.of(context).textTheme.bodyText1),
                      )
                    ],
                  ),
                );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ),
  ),
```

                                                                                       
## <div align="center">You are good to go 💯</div>
