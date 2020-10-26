


import 'package:XmPrep/components/default_button.dart';
import 'package:XmPrep/constants.dart';
import 'package:XmPrep/sign/sign/sign_in.dart';
import 'package:XmPrep/size_config.dart';
import 'package:XmPrep/splash/components/splash_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Digital Attendance, A new system for attendance !",
      "i": "images/s1-removebg-preview.png"
    },
    {
      "text":
      "Students can easily give the attendance",
      "i": "images/s2-removebg-preview.png"
    },
    {
      "text": "Launch the system and enjoy",
      "i": "images/s3-removebg-preview.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  splashData.length,
                      (index) => buildDot(index: index),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]['i'],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Spacer(flex: 3),

                    DefaultButton(
                      text: "Launch",
                      press: () {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}