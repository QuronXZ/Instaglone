import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaglone/peopleList.dart';
import 'package:instaglone/changePassword.dart';
import 'package:instaglone/edit_profile.dart';
import 'login.dart';
import 'widgets/follow_button.dart';
import 'widgets/choice_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  //Choice _selectedOption = choices[0];

  @override
  void initState() {
    super.initState();
    getData();
  }

  /*  void _select(Choice choice) {
    setState(() {
      _selectedOption = choice;
    });
  } */

  Future<void> followUser(String uid, String followId) async {
    try {
      var _firestore = FirebaseFirestore.instance;
      DocumentSnapshot snap =
          await _firestore.collection('Users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('Users').doc(uid).update({
          'followers': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('Users').doc(uid).update({
          'followers': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signout(String uid) async {
    await FirebaseAuth.instance.signOut();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();
      print("Got User");

      //get post LENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('Posts')
          .where('owner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      print("Got Posts");
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      ShowSnackBar(
        context,
        e.toString(),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: Text(
            userData['username'],
          ),
          centerTitle: false,
          actions: <Widget>[
            PopupMenuButton(
              //onSelected: _select,
              itemBuilder: (content) => [
                PopupMenuItem(
                    value: 1,
                    child: Text("Change Password"),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/changePass');
                      //context,
                      //MaterialPageRoute(
                      //builder: (context) => ChangePass(),
                      //),
                      // );
                    }),
                PopupMenuItem(
                    value: 2,
                    child: Text("Log Out"),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyLogin(),
                        ),
                      );
                    }),
              ],

              onSelected: (int menu) async {
                /* final navigatorKey = GlobalKey<NavigatorState>();
                // ignore: unused_label
                navigatorKey:
                navigatorKey; */
                if (menu == 1) {
                } else if (menu == 2) {
                  await signout(FirebaseAuth.instance.currentUser!.uid);
                  /* navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (context) => MyLogin())); */
                }
              },
              /* PopupMenuButton<Choice>(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.skip(0).map((Choice choice) {
                    return PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(choice.name),
                    );
                  }).toList();
                },
              ), */
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                /* children: [
                    ChoiceCard(choice: _selectedOption),
                    Column( */
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Image.network(
                          userData['profile'],
                        ),
                        radius: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(postLen, "Posts"),
                                buildStatColumn(followers, "Followers"),
                                buildStatColumn(following, "Following"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        text: 'Edit Profile',
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => EditProfile(
                                                uid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            text: 'Unfollow',
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['UID'],
                                              );

                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                          )
                                        : FollowButton(
                                            text: 'Follow',
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            borderColor: Colors.blue,
                                            function: () async {
                                              await followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['UID'],
                                              );

                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Text(
                      userData['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 1,
                    ),
                    child: Text(
                      userData['bio'],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Posts')
                  .where('owner', isEqualTo: widget.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 1.5,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];

                    return Container(
                      child: Image(
                        image: NetworkImage(snap['pic']),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      );
    }
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  void ShowSnackBar(BuildContext context, String string) {}
}
