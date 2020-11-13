import 'dart:math';
import 'package:XmPrep/Searchtheme2.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/model/AllCourseModel.dart';
import 'package:XmPrep/model/SuggestionCourse.dart';
import 'package:XmPrep/search_course/search_course_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:fluttertoast/fluttertoast.dart';


List<AllCourse>_resultcourselist = [];
String ID='';
List<dynamic> _resultlist = [];

class search_course2 extends StatelessWidget {

  static String routeName = "/search";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeachAppBarRecipe',
      theme:  Searchtheme2(),
      home: SeachAppBarRecipe2(title: 'SeachAppBarRecipe'),
    );
  }

}

class SeachAppBarRecipe2 extends StatefulWidget {
  SeachAppBarRecipe2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchAppBarRecipeState2 createState() => _SearchAppBarRecipeState2();
}

class _SearchAppBarRecipeState2 extends State<SeachAppBarRecipe2> {
  _SearchAppBarDelegate _searchDelegate;



  @override
  void initState() {

    getUserData();
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
            getALLSugList();

          });
        }
      });
    });

    super.initState();

    //Initializing search delegate with sorted list of English words
    _searchDelegate = _SearchAppBarDelegate();
    showSearchPage(context, _searchDelegate);
  }
  Future<void>getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      ID=userData.uid;
    });
  }
  Future <List<AllCourse>> getALLRESULTList() async {
    _resultcourselist.clear();

    DatabaseReference db =FirebaseDatabase.instance.reference().child("ALLCOURSE").child('');
    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      ;
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
        for(var i=0;i<=_resultcourselist.length;i++)
          print(_resultcourselist[i].CourseName);
      });
    });

  }
  Future <List<SuggestionCourse>> getALLSugList() async {
    _resultlist.clear();
    DatabaseReference db =FirebaseDatabase.instance.reference().child("SUGGESTIONLIST");
    db.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA =snap.value;
      ;
      if(DATA!=null){

        for(var individualkey in KEYS){
          _resultlist.add(DATA[individualkey]['CourseName']?? "",);
        }
      }
      else{

      }
      setState(() {
        for(var i=0;i<_resultcourselist.length;i++)
          print(_resultcourselist[i].CourseName);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Search'),
        actions: <Widget>[
          //Adding the search widget in AppBar
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            //Don't block the main thread
            onPressed: () {
              showSearchPage(context, _searchDelegate);
            },
          ),
        ],
      ),
      body: Scrollbar(
        //Displaying all English words in list in app's main page

      ),
    );
  }

  //Shows Search result
  void showSearchPage(BuildContext context,
      _SearchAppBarDelegate searchDelegate) async {
    final String selected = await showSearch<String>(
      context: context,
      delegate: searchDelegate,
    );

    if (selected != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Course Choice: $selected'),
        ),
      );
    }
  }
}



//Search delegate
class _SearchAppBarDelegate extends SearchDelegate<String> {


  List<dynamic>recent=[];
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty ?
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ) : IconButton(
        icon: const Icon(Icons.mic),
        tooltip: 'Voice input',
        onPressed: () {
          this.query = 'TBW: Get input from voice';
        },

      ),
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        this.close(context,null);
        Navigator.of(context).pop(true);

      },
    );
  }

  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: search_course_result(title:this.query.toString()),
      ),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<dynamic> suggestions = this.query.isEmpty
        ? recent
        : _resultlist.where((word) => word.startsWith(query));

    return _CourseuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this.recent.insert(0, suggestion);
        showResults(context);
      },
    );
  }
}

// Suggestions list widget displayed in the search page.
class _CourseuggestionList extends StatelessWidget {
  const _CourseuggestionList({this.suggestions, this.query, this.onSelected});

  final List<dynamic> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : CircleAvatar(
            child: ClipOval(
              child: new SizedBox(
                width: 150.0,
                height: 130.0,
                child: (Image.asset(
                  'images/ic_a',
                  fit: BoxFit.contain,
                  height: 100,
                  //color: s,
                )),
              ),
            ),
          ),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}