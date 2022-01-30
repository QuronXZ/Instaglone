import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? username;
  String? name;
  String? dob;
  String? email;
  String? bio;
  String? password;
  List? followers;
  List? following;
  String? profile;

  User(
      {this.username,
      this.name,
      this.password,
      this.email,
      this.dob,
      this.bio,
      this.followers,
      this.following,
      this.profile});

  List<User> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return User(
          username: dataMap['username'],
          name: dataMap['name'],
          password: dataMap['password'],
          email: dataMap['email'],
          dob: dataMap['dob'],
          bio: dataMap['bio'],
          followers: dataMap['followers'],
          following: dataMap['following'],
          profile: dataMap['profile']);
    }).toList();
  }

  String getUidFromUsername(String uname) {
    String uid = '';
    QuerySnapshot querySnap = FirebaseFirestore.instance
        .collection('User')
        .where('username', isEqualTo: uname)
        .snapshots() as QuerySnapshot;
    QueryDocumentSnapshot doc = querySnap.docs[0];
    if (doc.exists) {
      uid = doc.id;
    }
    print(uid);
    return uid;
  }
}
