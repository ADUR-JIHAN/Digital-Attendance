import 'package:XmPrep/size_config.dart';
import 'package:XmPrep/splash/components/body.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
