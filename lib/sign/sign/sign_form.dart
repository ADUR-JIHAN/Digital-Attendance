import 'package:XmPrep/components/custom_surfix_icon.dart';
import 'package:XmPrep/components/form_error.dart';
import 'package:XmPrep/constants.dart';
import 'package:XmPrep/helper/helper_functions.dart';
import 'package:XmPrep/home/homescreen.dart';
import 'package:XmPrep/services/auth_service.dart';
import 'package:XmPrep/services/database_service.dart';
import 'package:XmPrep/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
bool b;
class SignForm extends StatefulWidget {
  const SignForm({
    Key key,
    @required this.show,
  }) : super(key: key);
  final bool show;
  @override
  _SignFormState createState() => _SignFormState(show);
}

String NAME;

class _SignFormState extends State<SignForm> {
  _SignFormState(this.show);
  bool show;
  final _formKey = GlobalKey<FormState>();
  bool remember = false;
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _errorMessage = '';

  void onChange() {
    setState(() {
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              GestureDetector(
                onTap: () => null,
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              Spacer(),
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Save Password"),
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          SizedBox(
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  _formKey.currentState.save();
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        content: Row(children: <Widget>[
                          SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  valueColor: AlwaysStoppedAnimation(Colors.black)
                              )
                          ),

                          SizedBox(width: 10),

                          Text("SIGN IN.......")
                        ]),
                      )
                  );



                  signIn(emailController.text, passwordController.text)
                      .then((uid) => {
                            FirebaseDatabase.instance
                                .reference()
                                .child('User')
                                .once()
                                .then((DataSnapshot snapshot) {
                              Map<dynamic, dynamic> values = snapshot.value;
                              values.forEach((key, values) {
                                if (values['uid'] == uid) {
                                  setState(() {
                                    NAME = values['name'];
                                  });
                                }
                              });
                            }).then((value) =>
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => HomeScreen(NAME:NAME?? "")))
                            )})
                      .catchError((error) => {processError(error)});
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> signIn(final String email, final String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  void processError(final PlatformException error) {
    if (error.code == "ERROR_USER_NOT_FOUND") {
      setState(() {
        _errorMessage = "Unable to find user. Please register.";
      });
    } else if (error.code == "ERROR_WRONG_PASSWORD") {
      setState(() {
        _errorMessage = "Incorrect password.";
      });
    } else {
      setState(() {
        _errorMessage =
            "There was an error logging in. Please try again later.";
      });
    }
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
