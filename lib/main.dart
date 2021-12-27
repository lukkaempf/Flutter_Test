import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:testapp/pages/signup/sign_up.dart';
import 'package:testapp/pages/home/home.dart';
import 'package:testapp/pages/konto/konto.dart';
import 'package:testapp/constants/api_path.dart';
import 'package:testapp/pages/society/society.dart';

final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

Future<String> loginRequired(BuildContext context) async {
  String? token = await storage.read(key: 'token');
  if (token == null) {
    Navigator.pushReplacementNamed(context, 'login');
  }
  return token.toString();
}

Future<void> logout(context) async {
  await storage.delete(key: 'token');
  Navigator.of(context).pushReplacementNamed('login');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testapp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Navigation(),
      routes: {
        'home': (context) => Home(),
        'login': (context) => Login(),
        'signup': (context) => Signup(),
        'navigation': (context) => Navigation(),
        'konto': (context) => Konto(),
        'society': (context) => Society(),
      },
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

Color maincolor = Color(0xffe9e9e9);
Color shadowcolor = Color.fromRGBO(0, 0, 0, .3);

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String? errorMessage = '';
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('test'),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                      onSaved: (String? value) => _username = value!,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        errorText: errorMessage,
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
                ),
                SizedBox(
                  height: 100.0,
                ),
                Container(
                  child: TextFormField(
                      /* validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Passwort Feld leer';
                        } else if (errorMessage.isNotEmpty) {
                          return errorMessage;
                        }
                        return null;
                      }, */
                      obscureText: _isObscure,
                      onSaved: (String? value) => _password = value!,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                        errorText: errorMessage,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: maincolor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: maincolor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Passwort',
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'signup');
                        },
                        child: Text('Noch kein Konto? Jetzt Registieren')),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          errorMessage = '';
                          _formKey.currentState!.save();
                          Map map = {
                            'username': _username,
                            'password': _password
                          };

                          Map data = await login(context, map);
                          setState(() {
                            errorMessage = data['message'];
                          });
                        },
                        child: Text('Sign in'),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(10),
                            shadowColor:
                                MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

login(context, data) async {
  print(constantUrl + 'login');
  var url = Uri.parse(constantUrl + 'login');
  var result = await http.post(url, body: data);
  if (result.statusCode != 200) {
    return json.decode(result.body);
  }
  //String? value = await storage.read(key: 'token');
  writeToken(context, result);
  return json.decode(result.body);
}

writeToken(context, result) async {
  Map<String, dynamic> resultToJson = json.decode(result.body);
  await storage.write(key: 'token', value: resultToJson['token']);
  Navigator.pushReplacementNamed(context, 'navigation');
}
