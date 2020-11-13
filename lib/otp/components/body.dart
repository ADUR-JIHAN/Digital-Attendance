import 'dart:io';

import 'package:XmPrep/constants.dart';
import 'package:XmPrep/model/AttendanceClassModel.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:XmPrep/size_config.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'otp_form.dart';

class Body2 extends StatelessWidget {

  Course cl;
  NewUser usr;
  AttendanceClassModel acl;
  String time;
  Body2(this.cl,this.acl,this.usr,this.time);
  var one,two;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    var format = DateFormat("HH:mm");
    one = format.parse(DateFormat("HH:mm").format(today));
    two = format.parse(time);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                cl.Pic,
                width: screenWidth * 0.7,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: screenHeight * 0.000005,
              ),
              const Text(
                'Verification',
                style: TextStyle(fontSize: 28, color: Colors.black),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                'Enter A 6 digit number that was written on your board',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              buildTimer(),
              OtpForm(cl: cl,acl:acl,usr:usr,time:time,),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              GestureDetector(
                onTap: () {
                  // OTP code resend
                },
                child: Text(
                  "Resend OTP Code",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Row buildTimer() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 300-one.difference(two).inSeconds, end: 0.0),
          duration: Duration(seconds: 300-one.difference(two).inSeconds),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
