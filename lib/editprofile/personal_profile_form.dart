
import 'package:XmPrep/components/custom_surfix_icon.dart';
import 'package:XmPrep/components/default_button.dart';
import 'package:XmPrep/model/NewUser.dart';
import 'package:XmPrep/size_config.dart';
import 'package:flutter/material.dart';


class PersonalProfileForm extends StatefulWidget {
  NewUser usr;
  PersonalProfileForm(this.usr);
  @override
  _PersonalProfileFormState createState() => _PersonalProfileFormState(usr);
}

class _PersonalProfileFormState extends State<PersonalProfileForm> {
  NewUser usr;
  _PersonalProfileFormState(this.usr);
  final List<String> errors = [];
  String Name;
  String id;
  String phoneNumber;
  String sub;


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildUniField(),
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

  TextFormField buildUniField() {
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
        labelText: "University Name",
        hintText: usr.university_name,
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
      onSaved: (newValue) => phoneNumber = newValue,
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
        labelText: "Phone Number",
        hintText: usr.phone,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => Name = newValue,
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
        labelText: "Name",
        hintText: usr.name,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
