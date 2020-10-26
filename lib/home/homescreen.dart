import 'dart:io';

import 'package:XmPrep/DetailsScreen/encourse_detail_screen.dart';
import 'package:XmPrep/LIVEATTEND/LiveClass.dart';
import 'package:XmPrep/editprofile/EP.dart';
import 'package:XmPrep/model/AllCourseModel.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:XmPrep/model/CourseList.dart';
import 'package:XmPrep/model/CourseModel.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:XmPrep/model/carousels_model.dart';
import 'package:XmPrep/model/create_notes_form.dart';
import 'package:XmPrep/model/editprofile_title.dart';
import 'package:XmPrep/model/enrollment.dart';
import 'package:XmPrep/search_course2.dart';
import 'package:XmPrep/services/database_service.dart';
import 'package:XmPrep/sign/sign/sign_in.dart';
import 'package:XmPrep/size_config.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_state/flutter_super_state.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:async/async.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:firebase_database/firebase_database.dart';

List<Course>_courselist = [];
String ID='';
List<Course> enrollmentlist =[];
List<dynamic> enrollcoursecodelist=[];
class HomeScreen extends StatefulWidget {
  static String routeName = "/home_screen";
  final String NAME;
  const HomeScreen({
    Key key,
    @required this.NAME
  }):super(key:key);


  _HomeScreenState createState() => _HomeScreenState(NAME?? "");
}
NewUser usr;
String pic='';
class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.NAME);
  String NAME;

  @override
  void initState() {
    getUserData();
    FirebaseDatabase database = new FirebaseDatabase();
    final databaseReference = FirebaseDatabase.instance.reference();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    Course c;
    FirebaseDatabase.instance.reference().child('User').once().then((
        DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (values['uid'] == ID) {
          setState(() {

            getList(values['uid'].toString());
            NAME = values['name'];
            pic = values['pic'];
            usr = new NewUser(values['email'], values['id'], values['name'],values['pass'] ,values['phone'] ,values['pic'] , values['semester'],values['session'], values['sub'], values['uid'], values['university_name']);


          });
        }
      });
    });
    super.initState();
  }
 Future <List<Course>> getList(String Id) async {
    DatabaseReference db =FirebaseDatabase.instance.reference().child('Create_Course').child(Id);
    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      _courselist.clear();
      if(DATA!=null){
      for(var individualkey in KEYS){
        Course course = new Course(
            DATA[individualkey]['StartingTime']?? "",
            DATA[individualkey]['CourseName']?? "",
            DATA[individualkey]['pic']?? "",
            DATA[individualkey]['Semester']?? "",
            DATA[individualkey]['NumberOfClass']?? "",
            DATA[individualkey]['coursecode']?? "",
        );
        _courselist.add(course);
      }
      }
      else{

      }
      setState(() {
        for(var i=0;i<_courselist.length;i++)
        print(_courselist[i].CourseName);
      });
    });

  }

  Future<void>getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      enrollmentlist.clear();
      enrollcoursecodelist.clear();
      _courselist.clear();
      user = userData;
      ID=userData.uid;
      getList(ID);
      getEnCourseList(ID);
    });
  }

  Future <List<Course>> getEnCourseList(String Id) async {


    DatabaseReference db =FirebaseDatabase.instance.reference().child("User").child(Id).child('Enrollemtn');

    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
         if(DATA!=null){
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


  FirebaseUser user;

  int currentIndex = 0;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    int _current = 0;
    List<T> map<T>(List list, Function handler) {
      List<T> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }
      return result;
    }
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final today = DateTime.now();
    PageController _pageController=PageController(
      initialPage: 0,
      keepPage: true,
    );


    void bottomTapped(int index) {
      setState(() {
        currentIndex = index;
        _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    }

    Widget buildPageView() {
      return PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: <Widget>[
          Home(NAME),
          LiveClass(pic,NAME),
          EP(usr),

          ///Yellow(),
        ],
      );
    }
    String coursename, classtime,numberofclass;
    final List<String> errors = [];
    final List<String> appbarname=['Home','Live','Profile'];

    void addError({String error}) {
      if (!errors.contains(error))
        setState(() {
          errors.add(error);
        });
    }

    void removeError({String error}) {
      if (errors.contains(error))
        setState(() {
          errors.remove(error);
        });
    }

    @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }
    changePage(int index) {
      setState(() {
        currentIndex = index;
      });
    }
    Future<bool> _onBackPressed() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
            SizedBox(height: 16),
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(true),
              child: Text("YES"),
            ),
          ],
        ),
      ) ??
          false;
    }

    return WillPopScope(
      onWillPop:_onBackPressed,
        child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showModalBottomSheet2(context);
          },
          child: Icon(Icons.menu),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Text(appbarname[currentIndex]),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BubbleBottomBar(
          opacity: 0.2,
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          currentIndex: currentIndex,
          hasInk: true,
          inkColor: Colors.black12,
          hasNotch: true,
          onTap: (index) {
            bottomTapped(index);
          },
          items: [
            BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.dashboard,
                color: Colors.red,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.red,
              ),
              title: Text('Home'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.purpleAccent,
              icon: Icon(
                Icons.live_tv,
                color: Colors.purpleAccent,
              ),
              activeIcon: Icon(
                Icons.live_tv,
                color: Colors.purpleAccent,
              ),
              title: Text('Live Class'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              activeIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: Text('Profile'),
            ),




          ],
        ),
        body: buildPageView(),
    ));
  }

}




class Home extends StatefulWidget {
   Home(this.NAME);
  final String NAME;
  //final List<Course>_courselist;
  @override
  _HomeState createState() => _HomeState(NAME);
}

class _HomeState extends State<Home> {
  _HomeState(this.NAME);
  String NAME;
  //List<Course>_courseList;


  @override
  Widget build(BuildContext context) {
    List<T> map<T>(List list, Function handler) {
      List<T> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }
      return result;
    }
    final today = DateTime.now();
    int _current = 0;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(

        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Positioned(
                top: 0,
                height:height*0.6,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: const Radius.circular(30),
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 8, left: 10, right: 16, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "${DateFormat("EEEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            NAME,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 34,
                              color: Colors.deepOrange,
                            ),
                          ),
                          trailing: _RadialProgress(
                            width: width * 0.2,
                            height: width * 0.2,
                            progress: 0.2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            ClipOval(
                                child: Image.network(
                                  pic,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.fitWidth,
                                )),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _IngredientProgress(
                                  ingredient: "Present",
                                  progress: 0.3,
                                  progressColor: Colors.green,
                                  leftAmount: 72,
                                  width: width * 0.28,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _IngredientProgress(
                                  ingredient: "Absent",
                                  progress: 0.2,
                                  progressColor: Colors.red,
                                  leftAmount: 22,
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
              Positioned(
                top: height,
                left: 0,
                right: 0,
                bottom: 2,
                child: SingleChildScrollView(
                  child: Container(
                    height: height*0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 18,
                            right: 16,
                          ),
                          child: Text(
                            "Created Course",
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .05,
                                ),
                                ADDNOTES(
                                  categoryIcon: Icons.add_box,
                                  categoryName: "Create Course",
                                  selected: true,
                                ),
                                for(int i=0;i<_courselist.length;i++)
                                  CourseModel(cl: _courselist[i]?? ""),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 18,
                            right: 16,
                          ),
                          child: Text(
                            "Notice List",
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 140,
                                    child: Swiper(
                                      onIndexChanged: (index) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                      autoplay: true,
                                      layout: SwiperLayout.DEFAULT,
                                      itemCount: carousels.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  carousels[index].image,
                                                ),
                                                fit: BoxFit.cover),
                                          ),
                                        );
                                      },
                                    )),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: map<Widget>(carousels,
                                              (index, image) {
                                            return Container(
                                              alignment: Alignment.centerLeft,
                                              height: 6,
                                              width: 6,
                                              margin: EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _current == index
                                                      ? Colors.black54
                                                      : Colors.black12),
                                            );
                                          }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                            left: 18,
                            right: 16,
                          ),
                          child: Text(
                            "Enrollment Course",
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                for(int i=0;i<enrollmentlist.length;i++)
                                  ClassCard(cl:enrollmentlist[i],usr:usr),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
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
            Text("${leftAmount}classes"),
          ],
        ),
      ],
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
                      CreateNotesForm(),
                ]),
              ))
      )
  );

}

_showModalBottomSheet2(context) {
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
                      menu(),
                ]),
              ))));
}





class img extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    child: ClipOval(
                      child: new SizedBox(
                        width: 100.0,
                        height: 70.0,
                        child: (Image.asset(
                          'images/LOGO.png',
                          fit: BoxFit.contain,
                          height: 42,
                          color: Colors.greenAccent,
                        )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      size: 30.0,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width*.01,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        color: Colors.red,
                        icon: Icon(
                          Icons.search,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, search_course2.routeName);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.bookReader,
                          color: Colors.purpleAccent,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Books",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.assessment,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Dash Board",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.wc,
                          color: Colors.orange,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Teachers",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.pinkAccent,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Students",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.amber,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Sell & Buy",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.coins,
                          color: Colors.deepOrange,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Coin",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.settings_applications,
                          color: Colors.lightGreen,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Setting",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.cyan,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Notification",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.center_focus_weak,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => SignInScreen()));

                        },
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      width: 5,
                    ),
                    Text(
                      "Sign Out",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.lightBlueAccent,
                          fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
class ClassCard extends StatelessWidget {
  const ClassCard({
    Key key,
    @required this.cl,
    this.usr,

  }) : super(key: key);


  final Course cl;
  final NewUser usr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(builder: (context) => enclDetailScreen(cl:cl,usr:usr)));
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

var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

class ADDNOTES extends StatelessWidget {
  const ADDNOTES({
    Key key,
    @required this.categoryIcon,
    @required this.categoryName,
    @required this.selected,
  }) : super(key: key);

  final IconData categoryIcon;
  final String categoryName;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _showModalBottomSheet(context);
        },
        child: Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: selected ? Colors.black12 : Colors.white,
            border: Border.all(
                color: selected ? Colors.transparent : Colors.grey[200],
                width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[100],
                blurRadius: 15,
                offset: Offset(15, 0),
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        color: selected ? Colors.deepOrangeAccent : Colors.grey[200],
                        width: 1.5)),
                child: Icon(
                  categoryIcon,
                  color: Colors.deepOrange,
                  size: 30,
                ),
              ),
              SizedBox(height: 10),
              Text(
                categoryName,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 15),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 6, 0, 10),
                width: 0,
                height: 15,
                color: Colors.black26,
              ),
            ],
          ),
        ));
  }
}



