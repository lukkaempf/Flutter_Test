import 'package:flutter/material.dart';
import 'package:testapp/main.dart';
import 'package:testapp/pages/konto/konto.dart';
import 'package:testapp/pages/society/society.dart';
import 'package:testapp/utilis/services/rest_api_service.dart';
import 'package:testapp/utilis/services/local_api_service.dart';
import 'dart:io';

List listLoadPicturesFromCollection = [];

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
  List _screens = [Home(), Konto(), Society()];

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
                icon: Icon(Icons.account_circle_outlined), label: ''),
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

class _HomeState extends State<Home> with WidgetsBindingObserver {
  Future<void> getData() async {
    List pictures = await picturesInCollections();
    for (Map picture in pictures) {
      getPicture(picture['name']);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: FutureBuilder(
          future: loadPicturesFromCollection(),
          builder: (context, asyncSnapshot) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
                itemCount: listLoadPicturesFromCollection.length,
                itemBuilder: (BuildContext context, index) {
                  //GridOptions(layout: options[index]),
                  return Container(
                    //child: Text(asyncSnapshot.data.toString()),
                    child:
                        Image.file(File(listLoadPicturesFromCollection[index])),
                    //child: Image.file(File(
                    // '/storage/emulated/0/Android/data/com.example.testapp/files/response.jpg')),

                    //child: Text(listLoadPicturesFromCollection.toString()),

                    decoration: BoxDecoration(color: Colors.red),
                  );
                });
          }),
      onRefresh: () {
        setState(() {
          loadPicturesFromCollection();
        });

        return getData();
      },
    );
  }
}
