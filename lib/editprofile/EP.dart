import 'dart:io';
import 'dart:math';

import 'package:XmPrep/editprofile/academic_profile_form.dart';
import 'package:XmPrep/editprofile/personal_profile_form.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class EP extends StatefulWidget {
  final NewUser usr;
  EP(this.usr);
  _EPState createState() => _EPState(usr);
}

class _EPState extends State<EP> with SingleTickerProviderStateMixin {
  _EPState(this.usr);
  NewUser usr;
  TabController controller;
  File avatarImageFile, backgroundImageFile;
  String sex;
  String avatarImage, backgroundImage;
  var url;
  PickedFile image;

  Future getImage(bool isAvatar) async {
    var result = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isAvatar) {
        avatarImageFile = result;
      }
    });

    final _storage = FirebaseStorage.instance;

    //Select Image
    //image = await _picker.getImage(source: ImageSource.gallery);
    // var file = File(image.path);
    if (avatarImageFile != null) {
      //Upload to Firebase
      String c = new Random().toString().toString();
      var snapshot = await _storage
          .ref()
          .child(usr.id)
          .child('ProfilePic/')
          .putFile(avatarImageFile)
          .onComplete;
      Random random = new Random();
      int randomNumber = random.nextInt(1000);
      final today = DateTime.now();
      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        url = downloadUrl;
      });


      final databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child('User').child(usr.uid).update({
        "pic": url,
      }).then((_) {
        Toast.show("YOUR PIC SUCCESFULLY UPLOADED", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        print('pic uploaded.');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final today = DateTime.now();
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          new SliverPadding(
            padding: new EdgeInsets.all(4.0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate([
                TabBar(
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    new Tab(
                        icon: new Icon(
                          Icons.person_outline,
                          color: Colors.green,
                        ),
                        text: "Personal"),
                    new Tab(
                        icon: new Icon(
                          Icons.home,
                          color: Colors.red,
                        ),
                        text: "Academic"),
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
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .8,
                    child: Positioned(
                      top: 0,
                      height: height,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(10),
                        ),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(
                              top: 8, left: 20, right: 0, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  usr.id,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  usr.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 34,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                trailing: new Stack(
                                  children: <Widget>[
                                    (avatarImageFile == null)
                                        ? new Material(child:ClipOval(child:Image.network(
                                      usr.pic,
                                      fit: BoxFit.fill,
                                      width: 70.0,
                                      height: 70.0,
                                    )))
                                        : new Material(
                                      child: ClipOval(
                                        child: new Image.file(
                                          avatarImageFile,
                                          width: 70.0,
                                          height: 70.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(30.0)),
                                    ),
                                    new Material(
                                      child: new IconButton(
                                        icon: new Image.asset(
                                          'images/ic_camera.png',
                                          width: 40.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                        onPressed: () => getImage(true),
                                        padding: new EdgeInsets.all(0.0),
                                        highlightColor: Colors.black,
                                        iconSize: 70.0,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(30.0)),
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              PersonalProfileForm(usr),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //child: ,
                  ),
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .8,
                    child: Positioned(
                      top: 0,
                      height: height,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(10),
                        ),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(
                              top: 8, left: 20, right: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  usr.id,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  usr.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 34,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                trailing: new Stack(
                                  children: <Widget>[
                                    (avatarImageFile == null)
                                        ? new Material(child: ClipOval(
                                        child:new Image.network(
                                      usr.pic,
                                      fit: BoxFit.fill,
                                      width: 70.0,
                                      height: 70.0,
                                    )))
                                        : new Material(
                                      child: ClipOval(
                                        child: new Image.file(
                                          avatarImageFile,
                                          width: 70.0,
                                          height: 70.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(30.0)),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AcademicProfileForm(usr),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //child: ,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
