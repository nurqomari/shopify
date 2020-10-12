import 'dart:async';

import 'package:meta/meta.dart';

@immutable
class User {
  User(this.email, this.uid);

  String uid;
  String email;

  User.parse(json) {
    try {
      email = json["email"];
      uid = json["uid"];
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace.toString());
    }

    print(this.toString());
  }

  @override
  String toString() {
    return "user email: $email, user uid: $uid";
  }
}

abstract class AuthService {
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  void dispose();
}
