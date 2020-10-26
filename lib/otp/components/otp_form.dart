
import 'package:XmPrep/components/default_button.dart';
import 'package:XmPrep/constants.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/model/AttendanceClassModel.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:XmPrep/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class OtpForm extends StatefulWidget {

  const OtpForm({
    this.cl,
    this.acl,
    this.usr,
    Key key,
  }) : super(key: key);
  final Course cl;
  final AttendanceClassModel acl;
  final NewUser usr;

  @override
  _OtpFormState createState() => _OtpFormState(cl,acl,usr);
}
String ID ='';
class _OtpFormState extends State<OtpForm> {
  Course cl;
  NewUser usr;
  AttendanceClassModel acl;
  _OtpFormState(this.cl,this.acl,this.usr);
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;

  final otpController1 = new TextEditingController();
  final otpController2 = new TextEditingController();
  final otpController3 = new TextEditingController();
  final otpController4 = new TextEditingController();
  final otpController5 = new TextEditingController();
  final otpController6 = new TextEditingController();

  @override
  void initState() {
    final databaseReference = FirebaseDatabase.instance.reference();
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }
  Future<void>getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      ID=userData.uid;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: otpController1,
                  autofocus: true,
                  obscureText: false,
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: otpController2,
                  focusNode: pin2FocusNode,
                  obscureText:false,
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin3FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: otpController3,
                  focusNode: pin3FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin4FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: otpController4,
                  focusNode: pin4FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin5FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: otpController5,

                  focusNode: pin5FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin6FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: otpController6,
                  focusNode: pin6FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin6FocusNode.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.045),
          DefaultButton(
            text: "Submit",
            press: () {
              String name,sid,pic;
              final today = DateTime.now();
              String code = otpController1.text+otpController2.text+otpController3.text+otpController4.text+otpController5.text+otpController6.text;
              if(code == acl.ClassCode){
                Toast.show("Your course code matched:-Thankyou", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                Future<void>getUserData() async{
                  FirebaseUser userData = await FirebaseAuth.instance.currentUser();
                  setState(() {
                    ID=userData.uid;
                  });
                }
                FirebaseDatabase.instance.reference().child('User').once().then((
                    DataSnapshot snapshot) {
                  Map<dynamic, dynamic> values = snapshot.value;
                  values.forEach((key, values) {
                    if (values['uid'] == ID) {
                      setState(() {
                        name = values['name:'];
                        sid = values['id'];
                        pic = values['pic'];

                      });
                    }
                  });
                });
                final databaseReference = FirebaseDatabase.instance.reference();
                databaseReference.child('ATTEND')
                    .child(cl.coursecode).child(acl.Date).child("Students").push().set(
                    {
                      'StudentName':usr.name,
                      'StudentId':usr.id,
                      'Time': today.minute.toString(),
                      'PresentStatus': 'yes',
                      'coordinateofmine': '',
                      'StudentPic':usr.pic,
                      'StudentUserId':usr.uid,
                    });
                databaseReference.child('ATTENDSTU')
                    .child(cl.coursecode).child(usr.uid).push().set(
                    {
                       ''
                      'StudentName':usr.name,
                      'StudentId':usr.id,
                      'Time': acl.Date,
                      'PresentStatus': 'yes',
                      'coordinateofmine': '',
                      'StudentPic':usr.pic,
                      'StudentUserId':usr.uid,
                    });
                Navigator.push(context, new MaterialPageRoute(builder: (context) => HomeScreen()));

              }
              else{
                Toast.show("please try again:-Thankyou", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
              }


            },
          )
        ],
      ),
    );
  }
}
