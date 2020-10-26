import 'dart:math';

import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/model/AllCourseModel.dart';
import 'package:XmPrep/search_course/Genericcard.dart';
import 'package:XmPrep/search_course/coursecode_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:fluttertoast/fluttertoast.dart';

String Id='';
List<AllCourse>_resultcourselist = [];
class search_course_result extends StatefulWidget {
  search_course_result({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SearchAppBarRecipeState createState() => _SearchAppBarRecipeState(title);
}

class _SearchAppBarRecipeState extends State<search_course_result> {

  _SearchAppBarRecipeState(this.title){

  }
  String title;
  @override
  void initState() {

    getUserData();
    super.initState();
    getALLRESULTList(title);
    FirebaseDatabase database = new FirebaseDatabase();
    final databaseReference = FirebaseDatabase.instance.reference();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);




  }
  Future<void>getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      ID=userData.uid;
    });
  }
  Future <List<AllCourse>> getALLRESULTList(String title) async {
    _resultcourselist.clear();

    DatabaseReference db =FirebaseDatabase.instance.reference().child("ALLCOURSE").child(title);
    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      if(DATA!=null){

        for(var individualkey in KEYS){
          AllCourse course = new AllCourse(
            DATA[individualkey]['StartingTime']?? "",
            DATA[individualkey]['CourseName']?? "",
            DATA[individualkey]['pic']?? "",
            DATA[individualkey]['Semester']?? "",
            DATA[individualkey]['NumberOfClass']?? "",
            DATA[individualkey]['coursecode']?? "",
            DATA[individualkey]['CreatedBy']?? "",
            DATA[individualkey]['CreateUserId,']?? "",
            DATA[individualkey]['CreatedUserPhone;']?? "",
          );
          _resultcourselist.add(course);
        }
      }
      else{

      }
      setState(() {
        for(var i=0;i<_resultcourselist.length;i++) {
          print(_resultcourselist[i].CourseName);
          print(_resultcourselist[i].CourseName);
          print(_resultcourselist[i].CourseName);
          print(_resultcourselist[i].CourseName);
        }
      });
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Scrollbar(
        child: ListView.builder(
            itemCount: _resultcourselist.length,
            itemBuilder: (context, position) {
              var s = Colors.primaries[Random().nextInt(Colors.primaries.length)];
              int id = position;
              return GestureDetector(

                child: Column(children: <Widget>[
                  GenericCard(
                    cl: _resultcourselist[id],
                    id:ID,
                    imagePath: _resultcourselist[id].Pic,
                    title: _resultcourselist[id].CourseName,
                    subtitle: _resultcourselist[id].CreatedBy,
                    code: _resultcourselist[id].coursecode,
                    body:
                    'Visit ten places on our planet that are undergoing the biggest changes today.',
                    iconButtons: [
                      IconButton(
                        icon: Icon(Icons.assignment),
                        color: Colors.grey[500],
                        iconSize: 24.0,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.email),
                        color: Colors.grey[500],
                        iconSize: 24.0,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        color: Colors.grey[500],
                        iconSize: 24.0,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Divider(),

                ]),
                onTap: () {
                  _showModalBottomSheet(context);
                },
              );
            }

        ),

        //Displaying all English words in list in app's main page

      ),
    );
  }

//Shows Search result
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

                ]),
              ))
      )
  );

}
