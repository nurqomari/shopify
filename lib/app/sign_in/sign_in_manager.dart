import 'dart:async';

import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthService auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;

      final signMethod = await signInMethod();

      isLoading.value = false;

      return signMethod;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User> signInAnonymously() async {
    return await _signIn(auth.signInAnonymously);
  }

  Future<User> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<User> signInWithFacebook() async {
    return await _signIn(auth.signInWithFacebook);
  }
}
