import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/config/route.dart';
import 'package:flutter_ecommerce_app/src/pages/mainPage.dart';
import 'package:flutter_ecommerce_app/src/pages/product_detail.dart';
import 'package:flutter_ecommerce_app/src/widgets/customRoute.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_ecommerce_app/app/landing_page.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/auth_service_adapter.dart';
import 'package:provider/provider.dart';

import 'src/themes/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      builder: (_) => AuthServiceAdapter(),
      dispose: (_, AuthService authService) => authService.dispose(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
        routes: Routes.getRoute(),
      ),
    );
  }
}

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'E-Commerce ',
//      theme: AppTheme.lightTheme.copyWith(
//        textTheme: GoogleFonts.muliTextTheme(
//          Theme.of(context).textTheme,
//        ),
//      ),
//      debugShowCheckedModeBanner: false,
//      routes: Routes.getRoute(),
//      onGenerateRoute: (RouteSettings settings) {
//        if (settings.name.contains('detail')) {
//          return CustomRoute<bool>(
//              builder: (BuildContext context) => ProductDetailPage());
//        } else {
//          return CustomRoute<bool>(
//              builder: (BuildContext context) => MainPage());
//        }
//      },
//      initialRoute: "MainPage",
//
//    );
//  }
//}
