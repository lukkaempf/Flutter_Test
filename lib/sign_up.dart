import 'package:flutter/material.dart';

Color maincolor = Color(0xffe9e9e9);
Color shadowcolor = Color.fromRGBO(0, 0, 0, .3);

class Signup extends StatelessWidget {
  Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('test'),
        ),
        body: inputField());
  }
}

class inputField extends StatelessWidget {
  inputField({Key? key, username}) : super(key: key);

  String username = 'test';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          cursorColor: Colors.black,
          decoration: InputDecoration(
            errorText: 'test',
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: maincolor),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: maincolor),
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: 'Benutzername',
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
