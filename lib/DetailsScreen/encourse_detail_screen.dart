
import 'package:XmPrep/LIVEATTEND/attend_class.dart';
import 'package:XmPrep/model/AttendanceClassModel.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:XmPrep/model/Student.dart';
import 'package:XmPrep/model/classmembers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';
import 'package:commons/commons.dart';
import 'package:toast/toast.dart';

String securitycodes='';
String ID='';
AttendanceClassModel acl;
List<Student> mypresentlist=[];
List<AttendanceClassModel>_Attenclasslist = [];
class enclDetailScreen extends StatefulWidget {
  final Course cl;
  final NewUser usr;


  const enclDetailScreen(
      {Key key,
        @required this.cl,
        @required this.usr,
      }):super(key: key);


  _ClassDetailsScreenState createState() => _ClassDetailsScreenState(cl,usr);
}

class _ClassDetailsScreenState extends State<enclDetailScreen> {
  Course cl;
  NewUser usr;

  _ClassDetailsScreenState(this.cl,this.usr);

  @override
  void initState() {
    _Attenclasslist.clear();
    mypresentlist.clear();
    getUserData();
    getList();
    getListpresent();
    super.initState();

    FirebaseDatabase database = new FirebaseDatabase();
    final databaseReference = FirebaseDatabase.instance.reference();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);


  }
  Future <List<AttendanceClassModel>> getList() async {
    DatabaseReference db =FirebaseDatabase.instance.reference().child('Create_Course').child('AttenDance').child(cl.coursecode);
    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      _Attenclasslist.clear();
      if(DATA!=null){
        for(var individualkey in KEYS){
          AttendanceClassModel ATNDCLSMDL = new AttendanceClassModel(
            DATA[individualkey]['Date']?? "",
            DATA[individualkey]['Time']?? "",
            DATA[individualkey]['ClassCode']?? "",
            DATA[individualkey]['Presents']?? "",
            DATA[individualkey]['coordinateofmine']?? "",
            DATA[individualkey]['total']?? "",
          );
          _Attenclasslist.add(ATNDCLSMDL);
        }
      }
      else{

      }
      setState(() {
        for(var i=0;i<=_Attenclasslist.length;i++)
          print(_Attenclasslist[i].Date);
      });
    });

  }
  Future <List<Student>> getListpresent() async {
    DatabaseReference db =FirebaseDatabase.instance.reference().child('ATTENDSTU')
        .child(cl.coursecode).child(usr.uid);
    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      if(DATA!=null){
        for(var individualkey in KEYS){
          Student student = new Student(
            DATA[individualkey]['PresentStatus']?? "",
            DATA[individualkey]['StudentId']?? "",
            DATA[individualkey]['StudentName']?? "",
            DATA[individualkey]['StudentPic']?? "",
            DATA[individualkey]['StudentUserId']?? "",
            DATA[individualkey]['Time']?? "",
            DATA[individualkey]['coordinateofmine']?? "",
          );
          mypresentlist.add(student);
        }
      }
      else{

      }
      setState(() {
        for(var i=0;i<mypresentlist.length;i++)
          print(mypresentlist[i].StudentId);
      });
    });

  }

  Future<void>getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      ID=userData.uid;
    });
  }

  FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: const Color(0xFFE9E9E9),
        body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                snap: true,
                floating: true,
                backgroundColor: const Color(0xFFE9E9E9),
                elevation: 0,
                expandedHeight: 200,
                pinned: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: Text(
                  cl.CourseName?? "",
                  style: TextStyle(color: Colors.black),
                ),
                flexibleSpace: FlexibleSpaceBar(

                  background: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40)),
                    child: Image.network(
                      cl.Pic?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text(
                        "Course entry code:"+cl.coursecode?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      subtitle: Text(
                        cl.CourseName?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.check,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${cl.NumberOfClass?? ""} class",
                                style: TextStyle(color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${cl.StartingTime?? ""} ",
                                style: TextStyle(color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Class_Member(cl: cl,acl: acl,),
                    SizedBox(
                      height: 20,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 2,
                      child: Attend_Class(coursecode: cl.coursecode,cl: cl,usr:usr),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "   Class:-",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height*.8,
                  child: ListView.builder(
                      itemCount: mypresentlist.length,
                      itemBuilder: (context, position) {
                        var s= Colors.primaries[Random().nextInt(Colors.primaries.length)];
                        int id = position;

                        return GestureDetector(

                          child: Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 14.0, right: 14.0, top: 0, bottom: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [

                                  CircleAvatar(

                                    radius: 25.0,
                                    child: Text(mypresentlist[id].Time.substring(0,2)),
                                    backgroundColor: s,
                                    foregroundColor: Colors.white,
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "   "+mypresentlist[id].Time,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black87,
                                                    fontSize: 20.0),
                                              ),

                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width:15),
                                                  Text(
                                                    usr.name,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        color:s,
                                                        fontSize: 18.0),
                                                  ),
                                                  SizedBox(width:MediaQuery.of(context).size.width*0.5,),
                                                  Marker(present:mypresentlist[id].PresentStatus),


                                                ],
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),



                                ],
                              ),
                            ),
                            Divider(),
                          ]),
                        );

                      }),
                ),
              ),
            ]
        )

    );
  }


}
class Marker extends StatelessWidget {

  final String present;


  const Marker(
      {Key key,
        this.present})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        present=='yes'?
        Text(
          'Present',
          style: TextStyle(
            fontSize: 14,
            color: Colors.green,
            fontWeight: FontWeight.w700,
          ),
        ):Text(
          'Absent',
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
class _IngredientProgress extends StatelessWidget {
  final String ingredient;
  final int leftAmount;
  final double progress, width;
  final Color progressColor;

  const _IngredientProgress(
      {Key key,
        this.ingredient,
        this.leftAmount,
        this.progress,
        this.progressColor,
        this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 10,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: 10,
                  width: width * progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: progressColor,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Text("${leftAmount} presents"),
          ],
        ),
      ],
    );
  }
}

class InstructorTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          //builder: (context) => DoctorsInfo()
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xffFFEEE0),
            borderRadius: BorderRadius.circular(20)
        ),
        padding: EdgeInsets.symmetric(horizontal: 24,
            vertical: 18),
        child: Row(
          children: <Widget>[
            Image.asset("images/sir.jpg", height: 50,),
            SizedBox(width: 17,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("tcrname", style: TextStyle(
                    color: Color(0xffFC9535),
                    fontSize: 19
                ),),
                SizedBox(height: 2,),
                Text("IT Speailist", style: TextStyle(
                    fontSize: 15
                ),)
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,
                  vertical: 9),
              decoration: BoxDecoration(
                  color: Color(0xffFBB97C),
                  borderRadius: BorderRadius.circular(13)
              ),
              child: Text("Contact", style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500
              ),),
            )
          ],
        ),
      ),
    );
  }
}