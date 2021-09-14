import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

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
      home: Home(),
      routes: {'home': (context) => Home(), 'login': (context) => Login()},
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    loginRequired(context);
  }

/*   @override
  void dispose() {
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('test'),
      ),
      body: Center(
          child: Column(
        children: [
          FloatingActionButton(
            onPressed: () => logout(context),
            child: Text('Abmelden'),
            heroTag: '1',
          ),
          FloatingActionButton(
            onPressed: () => test1(),
            child: Text('Test'),
            heroTag: '2',
          )
        ],
      )),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String? errorMessage = '';
  bool _isObscure = true;

  Color maincolor = Color(0xffe9e9e9);
  Color shadowcolor = Color.fromRGBO(0, 0, 0, .3);

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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
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

                          /* foo(map);
                            FutureBuilder(
                                future: user,
                                builder: (context, snapshot) {
                                  print(snapshot.data);
                                  if (snapshot.hasData) {
                                    print('df');
                                    return Text('err');
                                  } else {
                                    return Text('test');
                                  }
                                }); */
                        },
                        child: Text('Sign in'),
                      ),
                    )
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
  //context, String username, String password, final formKey
  var url = Uri.parse('http://10.0.2.2:5000/api/login');
  var result = await http.post(url, body: data);
  if (result.statusCode != 200) {
    return json.decode(result.body);
  }

  //String? value = await storage.read(key: 'token');

  test(context, result);
  return json.decode(result.body);
}

test(context, result) async {
  Map<String, dynamic> resultToJson = json.decode(result.body);
  await storage.write(key: 'token', value: resultToJson['token']);
  Navigator.pushReplacementNamed(context, 'home');
}

Future<String> test1() async {
  var url = Uri.parse('http://10.0.2.2:5000/api/test/');

  //final token =
  //  'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNjMwNzE1MjU3fQ.iY-_UBE2NxlG5MTTtydWW01m1TGBOnMIGZfwG80Kjik';
  final token = await storage.read(key: 'token');

  var result = await http.get(url, headers: {
    'x-access-token': token.toString(),
    'Content-type': 'application/json'
  });
  print(result.body);
  return result.body.toString();
}
