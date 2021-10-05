import 'package:flutter/material.dart';
import 'package:testapp/main.dart';
import 'package:testapp/pages/konto/konto.dart';
import 'package:testapp/pages/signup/sign_up.dart';
import 'package:testapp/utilis/services/api_service.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  void initState() {
    super.initState();
    loginRequired(context);
  }

/*   @override
  void dispose() {
    super.dispose();
  } */

  int _currentIndex = 0;
  List _screens = [Home(), Konto()];

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('test'),
        ),
        body: Center(child: _screens[_currentIndex]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _updateIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_max_outlined), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: '')
          ],
        ));
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
