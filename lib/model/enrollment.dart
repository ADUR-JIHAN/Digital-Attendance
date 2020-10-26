
import 'package:XmPrep/DetailsScreen/encourse_detail_screen.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';
import 'section_title.dart';

String ID="";
class Enrollment_Class extends StatefulWidget {
  const Enrollment_Class({
    Key key,
  }) : super(key: key);

  Enrollment_ClassState createState()=> Enrollment_ClassState();
}
List<Course> enrollmentlist =[];
List<dynamic> enrollcoursecodelist=[];
class Enrollment_ClassState extends State<Enrollment_Class> {

  void initState() {

    FirebaseDatabase database = new FirebaseDatabase();
    final databaseReference = FirebaseDatabase.instance.reference();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    getUserData();
    getEnCourseList();
    super.initState();


  }
  Future<void>getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      ID=userData.uid;
    });
  }
  Future <List<Course>> getEnCourseList() async {

    DatabaseReference db =FirebaseDatabase.instance.reference().child("User").child(ID).child('Enrollemtn');
    enrollmentlist.clear();
    enrollcoursecodelist.clear();

    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      if(DATA!=null){

        for(var individualkey in KEYS){
           enrollcoursecodelist.add(DATA[individualkey]['EnrollCourseCode']?? "");
           print(DATA[individualkey]['EnrollCourseCode']?? "");
           DatabaseReference db = FirebaseDatabase.instance.reference().child(
               "Enrollment_Course").child(DATA[individualkey]['EnrollCourseCode']?? "");
           db.once().then((DataSnapshot snap) {
             var KEYS = snap.value.keys;
             var DATA = snap.value;
             if (DATA != null) {
               for (var individualkey in KEYS) {
                 Course course = new Course(
                   DATA[individualkey]['StartingTime']?? "",
                   DATA[individualkey]['CourseName']?? "",
                   DATA[individualkey]['pic']?? "",
                   DATA[individualkey]['Semester']?? "",
                   DATA[individualkey]['NumberOfClass']?? "",
                   DATA[individualkey]['coursecode']?? "",
                 );
                 print(course.CourseName);
                 enrollmentlist.add(course);
               }
             }
             else {

             }
           });

        }
      }
      else{

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Enrollement Class:-",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [

              for(int i=0;i<enrollmentlist.length;i++)
                ClassCard(cl: enrollmentlist[i]),

              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ),
      ],
    );
  }
}

class ClassCard extends StatelessWidget {
  const ClassCard({
    Key key,
    @required this.cl,

  }) : super(key: key);


  final Course cl;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(builder: (context) => enclDetailScreen(cl:cl)));
       },
        child: SizedBox(
          width: getProportionateScreenWidth(202),
          height: getProportionateScreenWidth(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  cl.Pic,
                  fit: BoxFit.cover,

                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: cl.CourseName+'\n',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "Tap for Details")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



ShowModalBottomSheet(context,Course cl) {

  showModalBottomSheet(
      context: context,
      builder: (context) =>
          Container(
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              color: Colors.white,
              margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[

                      //InstructorTile(name: cl.tcrlist[i]),

                    ]),
                  ))
          )
  );
}


