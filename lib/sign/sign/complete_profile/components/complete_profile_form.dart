import 'package:XmPrep/components/custom_surfix_icon.dart';
import 'package:XmPrep/components/form_error.dart';
import 'package:XmPrep/constants.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm(
      {Key key,

        @required this.email,
        @required this.pass,

      }):super(key:key);
  final String email,pass;
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState(email,pass);
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {

   String EMAIL,PASS;
   _CompleteProfileFormState(this.EMAIL,this.PASS);
  final nameTextEditController = new TextEditingController();
  final idTextEditController = new TextEditingController();
  final phoneTextEditController = new TextEditingController();
  final subTextEditController = new TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();


  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];


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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildIdField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildSubField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          SizedBox(
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB42827),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      CupertinoIcons.down_arrow,
                      color: Color(0xFFB42827),
                    ),
                  ),
                ],
              ),
              color: Colors.redAccent.withOpacity(0.3),
              onPressed: () {
                if (_formKey.currentState.validate()) {

                  print(EMAIL+" deki");

                  _firebaseAuth
                      .createUserWithEmailAndPassword(
                      email: EMAIL,
                      password: PASS)
                      .then((onValue) {
                    databaseReference.child('User').child(onValue.uid)
                        .set({
                      'email':EMAIL,
                      'pass': PASS,
                      'name':  nameTextEditController.text.toString(),
                      'id': idTextEditController.text.toString(),
                       'phone':phoneTextEditController.text.toString(),
                       'sub':subTextEditController.text.toString(),
                        'uid':onValue.uid,
                        'pic':'https://firebasestorage.googleapis.com/v0/b/exampreparation-124c5.appspot.com/o/laptop-user.png?alt=media&token=d4ec5151-bfa1-4da0-9f59-eab4c425cb26',
                         'university_name':'',
                         'semester':'',
                          'session':'',
                    }).then((userInfoValue) {
                      var userUpdateInfo = new UserUpdateInfo(); //create user update object
                      userUpdateInfo.displayName = nameTextEditController.text;
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => HomeScreen(NAME: nameTextEditController.text,)));
                    });
                  }).catchError((onError) {
                    //processError(onError);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildSubField() {
    return TextFormField(

      controller: subTextEditController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Subject",
        hintText: "Enter your subject Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneTextEditController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildIdField() {
    return TextFormField(
      controller: idTextEditController,

      decoration: InputDecoration(
        labelText: "ID",
        hintText: "Enter your ID ",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: nameTextEditController,

      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
