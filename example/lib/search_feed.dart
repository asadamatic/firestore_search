import 'package:example/data_model.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';

class SearchFeed extends StatefulWidget {
  const SearchFeed({Key? key}) : super(key: key);

  @override
  _SearchFeedState createState() => _SearchFeedState();
}

class _SearchFeedState extends State<SearchFeed> {
  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
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
  }
}
