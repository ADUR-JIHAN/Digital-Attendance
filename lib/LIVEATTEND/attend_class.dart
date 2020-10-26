
import 'package:XmPrep/model/AttendanceClassModel.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:XmPrep/model/section_title.dart';
import 'package:XmPrep/otp/otp_screen.dart';
import 'package:XmPrep/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Attend_Class extends StatefulWidget {
  final String coursecode;
  final NewUser usr;
  final Course cl;
  const Attend_Class({
    Key key,
    this.coursecode,
    this.cl,
    this.usr
  }) : super(key: key);
  _AtClass createState() => _AtClass(coursecode,cl,usr);
}
int state =0;
String ID='';
String sub='';
String dt ='';
AttendanceClassModel acl;

List<Course> enrollmentlist =[];
List <AttendanceClassModel> liveclasslist=[];
class _AtClass extends State<Attend_Class> {
  String coursecode;
  Course cl;
  NewUser usr;
  _AtClass(this.coursecode,this.cl,this.usr);

  @override
  void initState() {
    setState(() {
      state =0;
      sub = '';

    });
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
            state=1;
            sub = DATA[individualkey]['Name'] ?? "";
            dt = DATA[individualkey]['Date'] ?? "";
          });
          setState(() {
          AttendanceClassModel ATNDCLSMDL = new AttendanceClassModel(
            DATA[individualkey]['Date'] ?? "",
            DATA[individualkey]['Time'] ?? "",
            DATA[individualkey]['ClassCode'] ?? "",
            DATA[individualkey]['Presents'] ?? "",
            DATA[individualkey]['coordinateofmine'] ?? "",
            DATA[individualkey]['total'] ?? "",
          );
          acl = new AttendanceClassModel(
            DATA[individualkey]['Date'] ?? "",
            DATA[individualkey]['Time'] ?? "",
            DATA[individualkey]['ClassCode'] ?? "",
            DATA[individualkey]['Presents'] ?? "",
            DATA[individualkey]['coordinateofmine'] ?? "",
            DATA[individualkey]['total'] ?? "",
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
          Navigator.push(context, new MaterialPageRoute(builder: (context) => OtpScreen(cl, acl,usr)));
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
