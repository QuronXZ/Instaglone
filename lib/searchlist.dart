import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:instaglone/Models/user.dart';
import 'package:instaglone/profilepage.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  
  void callPeople(User usr) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProfileScreen(
                uid: User().getUidFromUsername(usr.username.toString()))));
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
      firestoreCollectionName: 'Users',
      searchBy: 'username',
      scaffoldBody: Center(),
      dataListFromSnapshot: User().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<User>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final User data = dataList[index];
                FirebaseFirestore.instance
                    .collection("Users")
                    .where('username', isEqualTo: data.username);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onDoubleTap: () => callPeople(data),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data.name}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        )),
                    InkWell(
                        onDoubleTap: () => callPeople(data),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: Text('${data.username}',
                              style: Theme.of(context).textTheme.bodyText1),
                        ))
                  ],
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
    );
  }
}
