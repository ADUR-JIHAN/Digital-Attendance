import 'package:XmPrep/components/custom_surfix_icon.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/model/AllCourseModel.dart';
import 'package:XmPrep/search_course/coursecode_form.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';


import 'package:sliding_card/sliding_card.dart';
import 'package:toast/toast.dart';
int s=0;
class GenericCard extends StatefulWidget {
  GenericCard(
      {Key key,
        this.cl,
      this.title,
        this.id,
      this.subtitle,
      this.body,this.code,
      this.iconButtons,
      this.imagePath,
      this.imageHeight = 184.0
      })
      : super(key: key);

  //variables
  final AllCourse cl;
  final String title;
  final String id;
  final String subtitle;
  final String body;
  final String imagePath;
  final double imageHeight;
  final String code;
  final List<IconButton> iconButtons;

  @override
  _GenericCardState createState() => _GenericCardState();

}
String password;
TextFormField buildPasswordFormField() {

  return TextFormField(
    obscureText: true,
    onSaved: (newValue) => password = newValue,
    onChanged: (value) {
      if (value.isNotEmpty) {
        //removeError(error: kPassNullError);
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: "Password",
      hintText: "Enter your password",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
    ),
  );
}

_showModalBottomSheet(context) {

  showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.white,
          margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child:
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  CourseCodeForm(),
                ]),
              ))
      )
  );

}


class _GenericCardState extends State<GenericCard> {
  final coursecodeController = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                        TextField(
                          controller: coursecodeController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Input the Course Coude'),
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          width: 320.0,
                          child: RaisedButton(
                            onPressed: () {

                              final databaseuser = FirebaseAuth.instance.currentUser();
                              final databaseReference = FirebaseDatabase.instance.reference();
                              String cd = coursecodeController.text;
                              if(widget.code == cd) {
                                databaseReference.child('User').child(widget.id).child('Enrollemtn')
                                    .push()
                                    .set({
                                  'CourseName': widget.cl.CourseName,
                                  'Semester': widget.cl.Semester,
                                  'StartingTime': widget.cl.Semester,
                                  'NumberOfClass': widget.cl.NumberOfClass,
                                  'pic': widget.cl.Pic,
                                  'coursecode':widget.cl.coursecode,
                                  'CreatedBy':widget.cl.coursecode,
                                  'CreateUserId':widget.cl.coursecode,
                                  'CreatedUserPhone':widget.cl.coursecode,

                                }).then((value) =>
                                {

                                });

                                //Navigator.of(context).pop();
                              }
                              Navigator.push(context, new MaterialPageRoute(builder: (context) => HomeScreen()));
                              //Navigator.of(context).pop();
                            },
                            child: Text(
                              "Okay",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xFF1BC0C5),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );});
    },

      child: Card(
        shadowColor: Colors.black12,
        clipBehavior: Clip.antiAlias,
        color: Colors.white60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(26.0),
                  topLeft: Radius.circular(26.0)),
              child: Image.network(
                widget.imagePath,
                fit: BoxFit.cover,
                height: widget.imageHeight,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            ListTile(
              title: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              subtitle: Text(
                widget.subtitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            SizedBox(
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Tap For Course Entry',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB42827),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        CupertinoIcons.ellipsis,
                        color: Color(0xFFB42827),
                      ),
                    ),
                  ],
                ),
                color: Colors.redAccent.withOpacity(0.3),
                onPressed: () {
                  CourseCodeForm();
                },
              ),
            ),

          ],
        ),
      ),
    );
    ;
  }
}
