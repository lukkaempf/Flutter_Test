import 'package:flutter/material.dart';
import 'package:testapp/pages/signup/sign_up.dart';
import 'package:meta/meta.dart';

class InputField extends StatefulWidget {
  final textfieldtext;
  final errorfieldtext;
  bool passwortfield;
  bool _isObscure = true;
  InputField(
      {Key? key,
      this.textfieldtext,
      this.errorfieldtext,
      this.passwortfield = false})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          onSaved: (String? value) {
            map[widget.textfieldtext] = value;
          },
          cursorColor: Colors.black,
          obscureText:
              (widget.passwortfield ? widget._isObscure : !widget._isObscure),
          decoration: InputDecoration(
            suffixIcon: (widget.passwortfield
                ? IconButton(
                    icon: Icon(widget._isObscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        widget._isObscure = !widget._isObscure;
                      });
                    })
                : Visibility(
                    child: Container(),
                    visible: false,
                  )),
            errorText: widget.errorfieldtext,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: maincolor),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: maincolor),
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.textfieldtext,
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
