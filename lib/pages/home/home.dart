import 'package:flutter/material.dart';
import 'package:testapp/main.dart';
import 'package:testapp/utilis/services/api_service.dart';

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
            onPressed: () => testGetData(),
            child: Text('Test'),
            heroTag: '2',
          )
        ],
      )),
    );
  }
}
