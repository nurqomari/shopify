//import 'package:firebase_auth_demo_flutter/app/sign_in/developer_menu.dart';
import 'dart:convert';

import 'package:flutter_ecommerce_app/app/sign_in/email_password_sign_in_page.dart';
import 'package:flutter_ecommerce_app/app/sign_in/sign_in_manager.dart';
import 'package:flutter_ecommerce_app/app/sign_in/social_sign_in_button.dart';
import 'package:flutter_ecommerce_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter_ecommerce_app/constants/strings.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecommerce_app/src/pages/mainPage.dart';

class SignInPageBuilder extends StatelessWidget {
  // P<ValueNotifier>
  //   P<SignInManager>(valueNotifier)
  //     SignInPage(value)
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) => Provider<SignInManager>(
              builder: (_) => SignInManager(auth: auth, isLoading: isLoading),
              child: Consumer<SignInManager>(
                builder: (_, SignInManager manager, __) => SignInPage._(
                            isLoading: isLoading.value,
                            manager: manager,
                            title: 'Firebase Auth Demo',
                          ),
              ),
            ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  SignInPage._({Key key, this.isLoading, this.manager, this.title}) : super(key: key);
  final SignInManager manager;
  final String title;
  final bool isLoading;

  Future<void> _showSignInError(BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      var user =  await manager.signInWithGoogle();
      print(user.toString());
      if (user!= null){
       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainPage()));
      }
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      var user = await manager.signInWithFacebook();
      print(user.toString());
      if (user == null) {SignInPageBuilder();}else{MainPage();}
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => EmailPasswordSignInPageBuilder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        elevation: 2.0,
////        title: Text(title),
//      ),
      // Hide developer menu while loading in progress.
      // This is so that it's not possible to switch auth service while a request is in progress
//      drawer: isLoading ? null : DeveloperMenu(),
      backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      Strings.signIn,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'assets/go-logo.png',
            text: Strings.signInWithGoogle,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
            color: Colors.white,
          ),
          SizedBox(height: 8),
          SocialSignInButton(
            assetName: 'assets/fb-logo.png',
            text: Strings.signInWithFacebook,
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
            color: Color(0xFF334D92),
          ),
          SizedBox(height: 8),
          SignInButton(
            text: Strings.signInWithEmail,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
            textColor: Colors.white,
            color: Colors.teal[700],
          ),
          SizedBox(height: 8),
          Text(
            Strings.or,
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          SignInButton(
            text: Strings.goAnonymous,
            color: Colors.lime[300],
            textColor: Colors.black,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
}
