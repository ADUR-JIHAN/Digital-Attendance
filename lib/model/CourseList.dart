import 'package:XmPrep/model/Course.dart';
import 'package:firebase_database/firebase_database.dart';
class CourseList{
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Course> courseList;
  int len(){
    return courseList.length;
  }

  CourseList({this.courseList});
}