




// We use name route
// All our routes will be available here
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/otp/otp_screen.dart';
import 'package:XmPrep/search_course2.dart';
import 'package:XmPrep/sign/sign/complete_profile/complete_profile_screen.dart';
import 'package:XmPrep/sign/sign/sign_in.dart';
import 'package:XmPrep/sign/sign/sign_up_screen.dart';
import 'package:XmPrep/splash/splash_screen.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName:(context)=> SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  search_course2.routeName:(context) => search_course2(),
  //search_course.routeName:(context) => search_course(),
  //OtpScreen.routeName:(context)=>OtpScreen(),

};
