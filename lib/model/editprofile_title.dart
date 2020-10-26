
import 'package:XmPrep/components/custom_surfix_icon.dart';
import 'package:flutter/material.dart';



class EditProfile_Title extends StatelessWidget {
  const EditProfile_Title({
    Key key,
    @required this.title,
    @required this.eText,
    @required this.press,
  }) : super(key: key);

  final String title;
  final String eText;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    String sub;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 20,
          fontWeight: FontWeight.w700),
          ),
        GestureDetector(
          onTap: press,
          child:TextFormField(
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
              labelText: title,
              hintText: eText.toString(),
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
            ),
          )
        ),
      ],
    );
  }
}
