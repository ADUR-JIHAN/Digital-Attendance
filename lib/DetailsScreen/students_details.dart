import 'dart:math';
import 'package:XmPrep/DetailsScreen/sliver_appbar_with_tabs.dart';
import 'package:XmPrep/model/AttendanceClassModel.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:XmPrep/model/Student.dart';
import 'package:XmPrep/model/Student2.dart';
import 'package:XmPrep/search_course/Genericcard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';

class StudentslistScreen extends StatefulWidget {
  StudentslistScreen({this.cl});
  final Course cl;
  _SilverAppBarWithTabBarState createState() => _SilverAppBarWithTabBarState(cl);
}
double sp=0.0;
double cp=0.0;
String ID="";
List <Student2>studentlist =[];
List <Student2>studentcrlist =[];
class _SilverAppBarWithTabBarState extends State<StudentslistScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  Course cl;
  AttendanceClassModel acl;
  _SilverAppBarWithTabBarState(this.cl);

  @override
  void initState() {


    getUserData();
    setState(() {
      studentlist.clear();
      studentcrlist.clear();
    });
    getList();
    setState(() {
      sp = studentlist.length/(studentcrlist.length+studentlist.length);
      cp = studentcrlist.length/(studentcrlist.length+studentlist.length);
    });
    FirebaseDatabase database = new FirebaseDatabase();
    final databaseReference = FirebaseDatabase.instance.reference();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    FirebaseDatabase.instance.reference().child('User').once().then((
        DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (values['uid'] == ID) {
          setState(() {
          });
        }
      });
    });
    super.initState();
    controller = TabController(
      length: 2,
      vsync: this,
    );
  }

  Future <List<Student>> getList() async {
    DatabaseReference db =FirebaseDatabase.instance.reference().child('CRSLIST').child(cl.CourseName).child(cl.coursecode);
    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      if(DATA!=null){
        for(var individualkey in KEYS) {
          Student2 student2 = new Student2(
            DATA[individualkey]['StudentId'] ?? "",
            DATA[individualkey]['StudentName'] ?? "",
            DATA[individualkey]['StudentPic'] ?? "",
            DATA[individualkey]['StudentUserId'] ?? "",
            DATA[individualkey]['Studenttype'] ?? "",
          );
          if (DATA[individualkey]['Studenttype'] == ' ') {
            studentlist.add(student2);
          }
          else if (DATA[individualkey]['Studenttype'] == 'cr') {
            studentcrlist.add(student2);
          }
        }
        }
      else{

      }
    });

  }

  Future<void>getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      ID=userData.uid;
    });
  }


  double _locationvalidate(double l1,double l2,double ll1,double ll2) {
    double distanceInMeters = Geolocator.distanceBetween(l1,l2, ll1,ll2);
    return distanceInMeters;
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final today = DateTime.now();
    return Scaffold(
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
                borderRadius: BorderRadius.all(Radius.circular(40))),
            title:  Text(
              cl.CourseName?? '',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 34,
                color: Colors.deepOrange,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                child: Positioned(
                  top: 40,
                  height:MediaQuery.of(context).size.height*0.2,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: const Radius.circular(20),
                    ),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          top: 40, left: 26, right: 16, bottom: 0),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.1,
                          ),
                          Row(
                            children: <Widget>[

                              ClipOval(child: Image.network(cl.Pic,fit: BoxFit.fill,width: 80,height: 80,)),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _IngredientProgress(
                                    ingredient: "STUDENTS",
                                    progress: .99,
                                    progressColor: Colors.green,
                                    leftAmount: studentcrlist.length+studentlist.length,
                                    width: width * 0.28,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _IngredientProgress(
                                    ingredient: "CR",
                                    progress: .1,
                                    progressColor: Colors.red,
                                    leftAmount: studentcrlist.length,
                                    width: width * 0.28,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.all(4.0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate([
                TabBar(
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    new Tab(icon: new Icon(Icons.account_box,color:Colors.green,), text: "STUDENTS"),
                    new Tab(
                        icon: new Icon(Icons.verified_user,color: Colors.red,), text: "CR"),
                  ],
                  controller: controller,
                ),
              ]),
            ),
          ),

          // SliverList(
          SliverFillRemaining(
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                Center(child: Container(
                  height: MediaQuery.of(context).size.height*.8,
                  child: ListView.builder(
                      itemCount: studentlist.length,
                      itemBuilder: (context, position) {
                        var s= Colors.primaries[Random().nextInt(Colors.primaries.length)];
                        int id = position;
                        {
                          return GestureDetector(

                            onTap: () {},
                            child: Column(children: <Widget>[

                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 14.0,
                                      right: 14.0,
                                      top: 0,
                                      bottom: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[

                                      ClipOval(
                                          child: Image.network(
                                            studentlist[id].StudentPic,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fitWidth,
                                          )
                                      ),

                                      Expanded(

                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0),
                                          child: Column(
                                            children: <Widget>[

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                ],
                                              ),

                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "   ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            color: Colors
                                                                .black87,
                                                            fontSize: 20.0),
                                                      ),
                                                      Text(
                                                        "   " +
                                                            studentlist[id]
                                                                .StudentId,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            color: Colors
                                                                .black87,
                                                            fontSize: 20.0),
                                                      ),
                                                      Text(
                                                        "      " +
                                                            studentlist[id]
                                                                .StudentName,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            color: Colors
                                                                .black87,
                                                            fontSize: 12.0),
                                                      ),

                                                    ],
                                                  ),

                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5),
                                                    child: LiteRollingSwitch(
                                                      value: true,
                                                      textOn: 'NOT CR',
                                                      textOff: 'CR',
                                                      colorOn: Colors.green,
                                                      colorOff: Colors.red,
                                                      iconOn: Icons.check,
                                                      iconOff: Icons
                                                          .not_interested,
                                                      onChanged: (bool state) {
                                                        print('turned ${(state)
                                                            ? 'on'
                                                            : 'off'}');
                                                      },
                                                    ),
                                                  )
                                                  //Customized
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
                        }
                      }),
                ),),
                Center(child: Container(
                  height: MediaQuery.of(context).size.height*.8,
                  child: ListView.builder(
                      itemCount: studentcrlist.length,
                      itemBuilder: (context, position) {
                        var s= Colors.primaries[Random().nextInt(Colors.primaries.length)];
                        int id = position;
                         {
                          return GestureDetector(

                            onTap: () {},
                            child: Column(children: <Widget>[
                              //if(studentpresentlist[id].PresentStatus=='' || _locationvalidate(double.parse(acl.latitude.toString()),double.parse(acl.longitude.toString()),double.parse(studentpresentlist[id].latitude.toString()),double.parse(studentpresentlist[id].longitude.toString()))>30.0000000)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 14.0,
                                    right: 14.0,
                                    top: 0,
                                    bottom: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    ClipOval(
                                        child: Image.network(
                                          studentabsencelist[id].StudentPic,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.fitWidth,
                                        )
                                    ),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0),
                                        child: Column(
                                          children: <Widget>[

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(
                                                      "   ",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: Colors.black87,
                                                          fontSize: 20.0),
                                                    ),
                                                    Text(
                                                      "   " + studentcrlist[id].StudentId,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: Colors.black87,
                                                          fontSize: 20.0),
                                                    ),
                                                    Text(
                                                      "      " + studentcrlist[id].StudentName,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: Colors.black87,
                                                          fontSize: 12.0),
                                                    ),

                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5),
                                                  child: LiteRollingSwitch(
                                                    value: false,
                                                    textOn: 'NOT CR',
                                                    textOff: 'CR',
                                                    colorOn: Colors.green,
                                                    colorOff: Colors.red,
                                                    iconOn: Icons.check,
                                                    iconOff: Icons
                                                        .not_interested,
                                                    onChanged: (bool state) {
                                                      print('turned ${(state)
                                                          ? 'on'
                                                          : 'off'}');
                                                    },
                                                  ),
                                                )
                                                //Customized
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
                        }
                      }),
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double height, width, progress;

  const _RadialProgress({Key key, this.height, this.width, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress: .8,
      ),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "80",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF200087),
                  ),
                ),
                TextSpan(text: "\n"),
                TextSpan(
                  text: "%",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF200087),
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

class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = Color(0xFF200087)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
            Text("${leftAmount} Students"),
          ],
        ),
      ],
    );
  }
}