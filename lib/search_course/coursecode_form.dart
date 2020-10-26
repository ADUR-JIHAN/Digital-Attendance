import 'package:XmPrep/components/custom_surfix_icon.dart';
import 'package:XmPrep/components/form_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../size_config.dart';

class CourseCodeForm extends StatefulWidget {
  const CourseCodeForm({
    Key key,
  }) : super(key: key);

  @override
  _CourseCodeFormState createState() => _CourseCodeFormState();
}


class _CourseCodeFormState extends State<CourseCodeForm> {
  TextEditingController passcontroller = new TextEditingController();
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


  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passcontroller,

      decoration: InputDecoration(
        labelText: "Class Code",
        hintText: "Enter your Class Code",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(5)),
          SizedBox(
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Submit',
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
              onPressed: () async{
                 {

                   Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: 'send request',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              },
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),

        ],
      ),
    );
  }
}