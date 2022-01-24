import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username = '';
  String name = '';
  String dob = '';
  String email = '';
  String bio = '';
  String password = '';
  List followers = [];
  List following = [];
}
