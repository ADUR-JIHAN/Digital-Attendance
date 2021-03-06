
import 'package:XmPrep/components/no_account_text.dart';
import 'package:XmPrep/components/socal_card.dart';
import 'package:XmPrep/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'sign_form.dart';

class SignInScreen extends StatelessWidget {
  bool show = false;
  final Function toggleView;
  SignInScreen({this.toggleView});
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        body:ModalProgressHUD(
        inAsyncCall: show, // here show is bool value, which is used to when to show the progess indicator
        child:SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Text(
                      "Welcome To Digital Attendance",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: getProportionateScreenWidth(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SignForm(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SocalCard(
                                          icon: "assets/icons/google-icon.svg",
                                          press: () {},
                                        ),
                                        SocalCard(
                                          icon: "assets/icons/facebook-2.svg",
                                          press: () {},
                                        ),
                                        SocalCard(
                                          icon: "assets/icons/twitter.svg",
                                          press: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: getProportionateScreenHeight(20)),
                    NoAccountText(),
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
