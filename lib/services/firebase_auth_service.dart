//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseAuthService implements AuthService {
//  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User usr = null;

  Stream<User> _userFromFirebase(User user) async* {
    if (user == null) {
      yield null;
    }
    yield User(
      uid: user.uid,
      email: user.email,
    );
  }

  @override
  Stream<User> get onAuthStateChanged {
//    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
    return _userFromFirebase(usr);
  }

  @override
  Future<User> signInAnonymously() async {
//    final FirebaseUser user = await _firebaseAuth.signInAnonymously();
//    return _userFromFirebase(user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
//    final FirebaseUser user = await _firebaseAuth.signInWithCredential(EmailAuthProvider.getCredential(
//      email: email,
//      password: password,
//    ));
//    return _userFromFirebase(user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) async {
//    final FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
//    return _userFromFirebase(user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
//    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final user = new User(uid: googleUser.id, email: googleUser.email);
        usr = user;
        _userFromFirebase(user);
        return  User(
          uid: user.uid,
          email: user.email,
        );
      } else {
        throw PlatformException(code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN', message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logInWithReadPermissions(<String>['public_profile']);
    if (result.accessToken != null) {
//       for profile details also use the below code
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');
      final profile = json.decode(graphResponse.body);
      final user = new User(uid:profile['id'] , email:profile['email']);

      usr = user;
      _userFromFirebase(user);
      return  User(
        uid: user.uid,
        email: user.email,
      );

    } else {
      throw PlatformException(code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<User> currentUser() async {
//    final FirebaseUser user = await _firebaseAuth.currentUser();
    return  User(
      uid: usr.uid,
      email: usr.email,
    );
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
//    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
