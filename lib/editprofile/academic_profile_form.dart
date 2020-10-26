
import 'package:XmPrep/components/custom_surfix_icon.dart';
import 'package:XmPrep/components/default_button.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:XmPrep/size_config.dart';
import 'package:flutter/material.dart';


class AcademicProfileForm extends StatefulWidget {
  final NewUser usr;
  AcademicProfileForm(this.usr);
  @override
  _AcademicProfileFormState createState() => _AcademicProfileFormState(usr);
}

class _AcademicProfileFormState extends State<AcademicProfileForm> {
  NewUser usr;
  _AcademicProfileFormState(this.usr);
  final List<String> errors = [];
  String id;
  String sub;
  String semester;
  String session;



  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildIdField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildSubField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildSemesterFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildSessionFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "UPDATE",
            press: () {

            },
          ),
        ],
      ),
    );
  }

  TextFormField buildSubField() {
    return TextFormField(
      onSaved: (newValue) => sub = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          //addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Subject Name",
        hintText: usr.sub,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildSemesterFormField() {
    return TextFormField(
      //keyboardType: TextInputType.phone,
      onSaved: (newValue) => semester = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          //addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Semester",
        hintText: usr.semester,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildIdField() {
    return TextFormField(
      onSaved: (newValue) => id = newValue,
      decoration: InputDecoration(
        labelText: "ID",
        hintText: usr.id,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildSessionFormField() {
    return TextFormField(
      onSaved: (newValue) => session = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          //addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Session",
        hintText: usr.session,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
