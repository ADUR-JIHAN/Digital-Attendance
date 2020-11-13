import 'dart:core';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:XmPrep/components/custom_surfix_icon.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';

class CreateNotesForm extends StatefulWidget {
  final String NAME;
  const CreateNotesForm({
    Key key,
    @required this.NAME
  }):super(key:key);
  @override
  _CreateNotesFormState createState() => _CreateNotesFormState(NAME);
}
String name;
class _CreateNotesFormState extends State<CreateNotesForm> {
  _CreateNotesFormState(this.NAME);
  String NAME;
  final List<String> errors = [];
  String course_name;
  String start_time;
  String total_class;
  String semester;
  String avatarImage, backgroundImage;
  File avatarImageFile, backgroundImageFile;
  var url;
  PickedFile image;

  final databaseReference = FirebaseDatabase.instance.reference();
  final courseTextEditController = new TextEditingController();
  final semesterTextEditController = new TextEditingController();
  final startingtimeTextEditController = new TextEditingController();
  final numberofclassTextEditController = new TextEditingController();

  uploadImage() async {
    final _storage = FirebaseStorage.instance;

    //Select Image
    //image = await _picker.getImage(source: ImageSource.gallery);
   // var file = File(image.path);
    if (backgroundImageFile != null) {
      //Upload to Firebase
      String c=new Random().toString().toString();
      var snapshot = await _storage
          .ref()
           .child(DateTime.now().toIso8601String())
          .child('CoursePic/')
          .putFile(backgroundImageFile)
          .onComplete;
      Random random = new Random();
      int randomNumber = random.nextInt(1000);
      final today = DateTime.now();
      var coursecode=randomNumber.toString()+courseTextEditController.text.replaceAll(' ', '');

      var downloadUrl = await snapshot.ref.getDownloadURL();
      FirebaseUser userData = await FirebaseAuth.instance.currentUser();
      setState(() {
        url=downloadUrl;
        name =NAME;
      });

      FirebaseDatabase.instance.reference().child('User').once().then((
          DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          if (values['uid'] == userData.uid) {
            setState(() {
              String sub = values['sub'];
              databaseReference.child("SUGGESTIONLIST").push().set({
                "CourseName":courseTextEditController.text,
              });
              databaseReference.child("ALLCOURSE").child(courseTextEditController.text).push().set({
                'CourseName': courseTextEditController.text,
                'Semester': semesterTextEditController.text,
                'StartingTime': startingtimeTextEditController.text,
                'NumberOfClass': numberofclassTextEditController.text,
                'pic': url,
                'coursecode':coursecode,
                'CreatedBy':values['name'],
                'CreateUserId':values['uid'],
                'CreatedUserPhone':values['phone']
              });

            });
          }
        });
      });

      databaseReference.child("Enrollment_Course").child(coursecode).push().set(
          {
            'CourseName': courseTextEditController.text,
            'Semester': semesterTextEditController.text,
            'StartingTime': startingtimeTextEditController.text,
            'NumberOfClass': numberofclassTextEditController.text,
            'pic': url,
            'coursecode':coursecode,
          });
      databaseReference.child('Create_Course').child(userData.uid).push().set({
        'CourseName': courseTextEditController.text,
        'Semester': semesterTextEditController.text,
        'StartingTime': startingtimeTextEditController.text,
        'NumberOfClass': numberofclassTextEditController.text,
        'pic': url,
        'coursecode':coursecode,
      }).then((userInfoValue) {

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)), //this right here
                child: Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "    Created Course!!!\n Your Course Code is "+coursecode,
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 320.0,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, new MaterialPageRoute(builder: (context) => HomeScreen(NAME:usr.name)));
                            },
                            child: Text(
                              "Okay",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xFF1BC0C5),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });

      }).catchError((onError) {
        Toast.show("SOMETHING ERROR", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      });

    } else {
      Toast.show("NO PATH RECIEVE", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  Future getImage(bool isAvatar) async {
    var result = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isAvatar) {
        avatarImageFile = result;
      } else {
        backgroundImageFile = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          new Container(
            child: new Stack(
              children: <Widget>[
                // Background
                (backgroundImageFile == null)
                    ? new Image.asset(
                  'images/bg_uit.jpg',
                  width: double.infinity,
                  height: 150.0,
                  fit: BoxFit.cover,
                )
                    : new Image.file(
                  backgroundImageFile,
                  width: double.infinity,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
                // Button change background
                new Positioned(
                  child: new Material(
                    child: new IconButton(
                      icon: new Image.asset(
                        'images/ic_camera.png',
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                      onPressed: () => getImage(false),
                      padding: new EdgeInsets.all(0.0),
                      highlightColor: Colors.black,
                      iconSize: 30.0,
                    ),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(30.0)),
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  right: 5.0,
                  top: 5.0,
                ),
              ],
            ),
            width: double.infinity,
            height: 180.0,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: getProportionateScreenHeight(10)),
              buildCourseNameField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildSemesterFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildStarttimeField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildtotalclassFormField(),
              SizedBox(height: getProportionateScreenHeight(20)),
              SizedBox(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Create',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFB42827),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          CupertinoIcons.add,
                          color: Color(0xFFB42827),
                        ),
                      ),
                    ],
                  ),
                  color: Colors.redAccent.withOpacity(0.3),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          content: Row(children: <Widget>[
                            SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    valueColor: AlwaysStoppedAnimation(Colors.black)
                                )
                            ),

                            SizedBox(width: 10),

                            Text("Creating Courses..........")
                          ]),
                        )
                    );
                    uploadImage();
                  },
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
      ),
    );
  }

  TextFormField buildCourseNameField() {
    return TextFormField(
      onSaved: (newValue) => course_name = newValue,
      controller: courseTextEditController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          //addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Course Name",
        hintText: "Enter the course name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildSemesterFormField() {
    return TextFormField(
      //keyboardType: TextInputType.phone,
      controller: semesterTextEditController,
      onSaved: (newValue) => semester = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          //addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Semester",
        hintText: "Enter the Semester",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildStarttimeField() {
    return TextFormField(
      controller: startingtimeTextEditController,
      onSaved: (newValue) => start_time = newValue,
      decoration: InputDecoration(
        labelText: "Starting time",
        hintText: "Enter the Starting time",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildtotalclassFormField() {
    return TextFormField(
      controller: numberofclassTextEditController,
      onSaved: (newValue) => total_class = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          //addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Number of Classes",
        hintText: "Enter the approximate number of Classes",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
