import 'package:flutter/material.dart';
import 'package:testapp/utilis/services/local_api_service.dart';
import 'package:testapp/main.dart';
import 'package:testapp/utilis/services/rest_api_service.dart';

class Konto extends StatelessWidget {
  const Konto({Key? key}) : super(key: key);

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
          onPressed: () => getSociety(),
          child: Text('Test'),
          heroTag: '2',
        ),
        FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('society'),
          child: Text('society'),
          heroTag: '3',
        )
      ],
    );
  }
}
