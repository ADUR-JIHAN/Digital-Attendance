
import 'dart:io';

import 'package:XmPrep/model/AttendanceClassModel.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:XmPrep/model/proxy.dart';
import 'package:XmPrep/model/section_title.dart';
import 'package:XmPrep/otp/otp_screen.dart';
import 'package:XmPrep/size_config.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:toast/toast.dart';
String proxygiver;


class Attend_Class extends StatefulWidget {
  final String coursecode;
  final NewUser usr;
  final Course cl;

  const Attend_Class({
    Key key,
    this.coursecode,
    this.cl,
    this.usr,
  }) : super(key: key);
  _AtClass createState() => _AtClass(coursecode,cl,usr,);
}
var format = DateFormat("HH:mm");
var one ,two;
int state =0;
String ID='';
String sub='';
String s;
String dt ='';
AttendanceClassModel acl;
String time;
List<PXY> proxy=[];
List<Course> enrollmentlist =[];
List <AttendanceClassModel> liveclasslist=[];
class _AtClass extends State<Attend_Class> {
  String coursecode;
  Course cl;
  NewUser usr;
  _AtClass(this.coursecode,this.cl,this.usr,);

  @override
  void initState() {
    setState(() {
      state =0;
      sub = '';
    });
    getList2();
    enrollmentlist.clear();
    liveclasslist.clear();
    getUserData();
    getList();
    FirebaseDatabase database = new FirebaseDatabase();
    final databaseReference = FirebaseDatabase.instance.reference();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    super.initState();
  }
  Future <List<AttendanceClassModel>> getList() async {
    final today = DateTime.now();
    String date = DateFormat("EEEEE").format(today) +
        DateFormat("dMMMM").format(today);

    DatabaseReference db = FirebaseDatabase.instance.reference().child('ATTEND')
        .child(cl.coursecode).child(date);

    db.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      if (DATA != null) {
        for (var individualkey in KEYS) {
          setState(() {
            var format = DateFormat("HH:mm");
            final today = DateTime.now();
             one = format.parse(DateFormat("HH:mm").format(today));
             two = format.parse(DATA[individualkey]['Time']);
             time = DATA[individualkey]['Time'];
            if(one.difference(two).inSeconds <= 300) {
              state=1;
            }
            sub = DATA[individualkey]['Name'] ?? "";
            dt = DATA[individualkey]['Date'] ?? "";
          });
          setState(() {
          AttendanceClassModel ATNDCLSMDL = new AttendanceClassModel(
            DATA[individualkey]['Date'] ?? "",
            DATA[individualkey]['Time'] ?? "",
            DATA[individualkey]['ClassCode'] ?? "",
            DATA[individualkey]['Presents'] ?? "",
            DATA[individualkey]['latitude']?? "",
            DATA[individualkey]['longitude']?? "",
            DATA[individualkey]['period_number'] ?? "",
          );
          acl = new AttendanceClassModel(
            DATA[individualkey]['Date'] ?? "",
            DATA[individualkey]['Time'] ?? "",
            DATA[individualkey]['ClassCode'] ?? "",
            DATA[individualkey]['Presents'] ?? "",
            DATA[individualkey]['latitude']?? "",
            DATA[individualkey]['longitude']?? "",
            DATA[individualkey]['period_number'] ?? "",
          );

          liveclasslist.add(ATNDCLSMDL);
        });


        }

      }
      else {

      }
    });
  }

  Future<void>getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      ID=userData.uid;
    });
  }
  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
  Future <List<PXY>> getList2() async {
    String deviceId = await _getId();
    DatabaseReference db =FirebaseDatabase.instance.reference().child('AT')
        .child(cl.coursecode).child(acl.Date).child(deviceId);
    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      if(DATA!=null){
        for(var individualkey in KEYS) {
          PXY pxy = new PXY(
            DATA[individualkey]['Done'] ?? "",
          );
          proxy.add(pxy);
        }
      }
      else{

      }
      setState(() {
        for(var i=0;i<proxy.length;i++)
          print(proxy[i].done);
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: getProportionateScreenWidth(20)),
      Padding(
      padding:
      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
       child: SectionTitle(
       title: "Give Attendance",
        press: () {},
      ),
     ),
      if(state == 1)
      Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap:() {
          if(proxy.isEmpty) {
            setState(() {
              var format = DateFormat("HH:mm");
              final today = DateTime.now();
              one = format.parse(DateFormat("HH:mm").format(today));
            });

            if (one
                .difference(two)
                .inSeconds <= 300)
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => OtpScreen(cl, acl, usr, time)));
            else
              Toast.show("Sorry!! Time is finished:-Thankyou", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          else{
            Toast.show("Sorry!! Already a user submit attendance from this devices.....", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }

        },
        child: SizedBox(
          width: getProportionateScreenWidth(382),
          height: getProportionateScreenWidth(130),
          child: Container(
            // height: 90,
            width: double.infinity,
            margin: EdgeInsets.all(getProportionateScreenWidth(25)),
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(25),
              vertical: getProportionateScreenWidth(15),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(text: "Click For Attendane\n"),
                  TextSpan(
                    text: sub+"\n",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text:dt),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        ]
    );
  }
}
