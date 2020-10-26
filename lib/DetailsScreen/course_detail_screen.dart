
import 'package:XmPrep/DetailsScreen/sliver_appbar_with_tabs.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/model/AttendanceClassModel.dart';
import 'package:XmPrep/model/Course.dart';
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
List<AttendanceClassModel>_Attenclasslist = [];
class clDetailScreen extends StatefulWidget {
  final Course cl;
  final AttendanceClassModel acl;


  const clDetailScreen(
      {Key key,
        @required this.cl,
        this.acl
      }):super(key: key);


  _ClassDetailsScreenState createState() => _ClassDetailsScreenState(cl,acl);
}

class _ClassDetailsScreenState extends State<clDetailScreen> {
  Course cl;
  AttendanceClassModel acl;

  _ClassDetailsScreenState(this.cl,this.acl)
  {

  }
  @override
  void initState() {
    _Attenclasslist.clear();
    getUserData();
    getList();
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
        for(var i=0;i<_Attenclasslist.length;i++)
          print(_Attenclasslist[i].Date);
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            int a = 0;
            Random random = new Random();
            int randomNumber = random.nextInt(1000000);
            final today = DateTime.now();
            String date = DateFormat("EEEEE").format(today)+DateFormat("dMMMM").format(today);
            for (int i = 0; i < _Attenclasslist.length; i++) {
              if (_Attenclasslist[i].Date == DateFormat("d MMMM").format(today)) {
                a = 1;
              }
            }
            if (a != 1) {
              var securitycode = randomNumber.toString();

              final databaseReference = FirebaseDatabase.instance.reference();
              setState(() {
                securitycodes = securitycode;
              });
              databaseReference.child('Create_Course').child('AttenDance')
                  .child(cl.coursecode).child(date).set(
                  {
                    'Date': DateFormat("d MMMM").format(today),
                    'Time': today.minute.toString(),
                    'ClassCode': securitycode,
                    'Presents': '',
                    'coordinateofmine': '',
                    'total': ''
                  }).then((value) =>
              databaseReference.child('ATTEND')
                  .child(cl.coursecode).child(date).push().set(
                  {
                    'Name':cl.CourseName,
                    'Date': DateFormat("d MMMM").format(today),
                    'Time': today.minute.toString(),
                    'ClassCode': securitycode,
                    'Presents': '',
                    'coordinateofmine': '',
                    'total': ''
                  })
                  .then((value) =>
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
                                  "    Successfuly Created Class!!!\n Your Class Code is "+securitycode,
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        getList();
                                      });
                                      Navigator.of(context).pop();
                                      Navigator.push(context, new MaterialPageRoute(builder: (context) => HomeScreen()));

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
                      );}))

              );
            }
            else {
              Toast.show("You Can not create two classes in a day:-Thankyou", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          }
          },

          child: Icon(Icons.create_new_folder),
          backgroundColor: Colors.cyan,
        ),
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
                    Class_Member(acl:acl,cl:cl),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Class:-",
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
                      itemCount: _Attenclasslist.length,
                      itemBuilder: (context, position) {
                        var s= Colors.primaries[Random().nextInt(Colors.primaries.length)];
                        int id = position;
                        //DateClass dc =DateClassGenerator.getdateclassList(position);
                        return GestureDetector(

                          onLongPress: () {
                            successDialog(
                                context,
                                "Todays class code is: "+_Attenclasslist[id].ClassCode?? ""


                            );
                          },

                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new EnrollAttendanceScreen(cl: cl,acl: _Attenclasslist[id],)));
                          },
                          child: Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 14.0, right: 14.0, top: 0, bottom: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[


                                  CircleAvatar(

                                    radius: 25.0,
                                    child: Text(_Attenclasslist[id].Date.substring(0,2)?? ""),
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
                                                "   "+_Attenclasslist[id].Date,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
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
                                                  Text(
                                                    "      Class Code:-"+_Attenclasslist[id].ClassCode,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        color:s,
                                                        fontSize: 10.0),
                                                  ),


                                                ],
                                              ),
                                              _IngredientProgress(
                                                ingredient: "Presents",
                                                progress: (40)/50,
                                                progressColor: Colors.green,
                                                leftAmount: 40,
                                                width: 40,
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