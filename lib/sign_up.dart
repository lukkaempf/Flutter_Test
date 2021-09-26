import 'package:flutter/material.dart';
import 'package:testapp/widgets/input_field.dart';
import 'package:testapp/utilis/services/api_service.dart';

Color maincolor = Color(0xffe9e9e9);
Color shadowcolor = Color.fromRGBO(0, 0, 0, .3);
Map map = {};

class Signup extends StatelessWidget {
  Signup({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('test'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InputField(
                  textfieldtext: 'Vorname',
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Name',
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Benutzername',
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Passwort',
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Passwort2',
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState!.save();
                      print(map);
                      Map result = await fetchData("signup", map);
                      print(result);
                    },
                    child: Text('Submit'))
              ],
            ),
          ),
        ));
  }
}
