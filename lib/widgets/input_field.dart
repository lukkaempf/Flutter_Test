import 'package:flutter/material.dart';
import 'package:testapp/sign_up.dart';

class InputField extends StatelessWidget {
  final textfieldtext;
  final String? usernamevalue = '';
  InputField({Key? key, this.textfieldtext}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          onSaved: (String? value) {
            map[textfieldtext] = value;
          },
          cursorColor: Colors.black,
          decoration: InputDecoration(
            errorText: 'Error with $textfieldtext',
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: maincolor),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: maincolor),
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: textfieldtext,
            fillColor: maincolor,
            filled: true,
          )),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: shadowcolor,
          blurRadius: 30,
          offset: const Offset(0, 20),
        ),
      ]),
    );
  }
}
