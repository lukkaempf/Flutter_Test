import 'package:flutter/material.dart';
import 'package:testapp/widgets/input_field.dart';
import 'package:testapp/utilis/services/rest_api_service.dart';

Color maincolor = Color(0xffe9e9e9);
Color shadowcolor = Color.fromRGBO(0, 0, 0, .3);
Map map = {};

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  String? errorVorname = '';
  String? errorName = '';
  String? errorMail = '';
  String? errorBenutzername = '';
  String? errorPasswort = '';

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
                  errorfieldtext: errorVorname,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Name',
                  errorfieldtext: errorName,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Mail',
                  errorfieldtext: errorMail,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Benutzername',
                  errorfieldtext: errorBenutzername,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Passwort',
                  errorfieldtext: errorPasswort,
                  passwortfield: true,
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  textfieldtext: 'Passwort2',
                  errorfieldtext: errorPasswort,
                  passwortfield: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      errorVorname = '';
                      errorName = '';
                      errorMail = '';
                      errorBenutzername = '';
                      errorPasswort = '';
                      _formKey.currentState!.save();
                      Map result = await fetchData("signup", map);
                      print(result);
                      setState(() {
                        if (result['errorAll'] != null) {
                          errorVorname = result['errorAll'];
                          errorName = result['errorAll'];
                          errorMail = result['errorAll'];
                          errorBenutzername = result['errorAll'];
                          errorPasswort = result['errorAll'];
                          errorPasswort = result['errorAll'];
                        }
                        result['errorPasswort'] != null
                            ? errorPasswort = result['errorPasswort']
                            : '';
                        result['errorBenutzername'] != null
                            ? errorBenutzername = result['errorBenutzername']
                            : '';
                      });
                      result['message'] == 'erfolgreich'
                          ? Navigator.pushReplacementNamed(context, 'login')
                          : '';
                    },
                    child: Text('Submit'))
              ],
            ),
          ),
        ));
  }
}
