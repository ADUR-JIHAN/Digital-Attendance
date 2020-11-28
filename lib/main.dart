import 'package:XmPrep/routes.dart';
import 'package:XmPrep/splash/splash_screen.dart';
import 'package:XmPrep/theme.dart';
import 'package:flutter/material.dart';
import 'home/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XmPreparation',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      // initialRoute: HomeScreen.routeName,
      initialRoute: SplashScreen.routeName,
      routes: routes,
      //home: ProfileScreen(),
    );
  }
}

