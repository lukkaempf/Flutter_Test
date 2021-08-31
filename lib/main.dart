import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
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
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();

  Color maincolor = Color(0xffe9e9e9);

  Color shadowcolor = Color.fromRGBO(0, 0, 0, .3);

  String _username = '';
  String _password = '';

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
                      validator: (value) =>
                          (value?.isEmpty ?? true ? 'Enter an email' : null),
                      onSaved: (String? value) => _username = value!,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          hintText: 'Benutzername',
                          fillColor: maincolor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: maincolor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: maincolor),
                            borderRadius: BorderRadius.circular(15),
                          ))),
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
                      validator: (value) => (value?.isEmpty ?? true
                          ? 'Enter the passwort'
                          : null),
                      onSaved: (String? value) => _password = value!,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          hintText: 'Passwort',
                          fillColor: maincolor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: maincolor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: maincolor),
                            borderRadius: BorderRadius.circular(15),
                          ))),
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
                        onPressed: _submit,
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_username);
      print(_password);
      Map map = {'username': _username, 'password': _password};

      login(map);
    }
  }
}

Future<void> login(Map listdata) async {
  print(listdata);
  var url = Uri.parse('http://localhost:5000/api/login');
  var result = await http.post(url, body: listdata);
  print(result.body);
}
