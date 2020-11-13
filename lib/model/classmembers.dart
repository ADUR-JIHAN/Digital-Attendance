
import 'package:XmPrep/DetailsScreen/students_details.dart';
import 'package:XmPrep/model/AttendanceClassModel.dart';
import 'package:XmPrep/model/Course.dart';
import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';
import 'section_title.dart';

class Class_Member extends StatelessWidget {
  const Class_Member({
    Key key,
    @required this.acl,
    this.cl
  }) : super(key: key);
  final AttendanceClassModel acl;
  final Course cl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Members:-",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              MemberCategoryCard(
                acl: acl,
                cl:cl,
                image: "images/sir.jpg",
                name: "Instructors",
                press: () {},
              ),
              MemberCategoryCard(
                cl: cl,
                acl: acl,
                image: "images/students.jpg",
                name: "Students",
                press: () {},
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ),
      ],
    );
  }
}

class MemberCategoryCard extends StatelessWidget {
  const MemberCategoryCard({
    Key key,
    this.cl,
    @required this.acl,
    @required this.name,
    @required this.image,
    @required this.press,
  }) : super(key: key);
  final  Course cl;
  final String name, image;
  final AttendanceClassModel acl;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: (){
          if(name=='Instructors')
          ShowModalBottomSheet(context,acl,cl);
          else if(name=="Students"){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new StudentslistScreen(cl: cl,)));
          }
       },
        child: SizedBox(
          width: getProportionateScreenWidth(202),
          height: getProportionateScreenWidth(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
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
                          text: "$name\n",
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


class InstructorTile extends StatelessWidget {
  const InstructorTile({
    Key key,
    this.cl,
    @required this.acl,
  }) : super(key: key);
  final AttendanceClassModel acl;
  final Course cl;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          //builder: (context) => DoctorsInfo()
        ));
      },
         child: Column(
         children:<Widget>[
           SizedBox(height: 4,),
         Container(
        decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(20)
        ),
        padding: EdgeInsets.symmetric(horizontal: 24,
            vertical: 25),
        child: Row(
          children: <Widget>[
            Image.network(cl.Pic, height: 50,),
            SizedBox(width: 17,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("bla bla", style: TextStyle(
                    color: Colors.deepOrange,
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
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(13)
              ),
              child: Text("Contact", style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500
              ),),
            ),
          ],
        ),
      ),
    ]
    )
    )
    );
  }
}

ShowModalBottomSheet(context,AttendanceClassModel acl,Course cl) {

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

                      InstructorTile(acl:acl,cl: cl,),

                    ]),
                  ))
          )
  );
}
