import 'package:flutter/material.dart';

import 'navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OMSAT',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: OmsatNavigationToolbar(),
    );
  }
}
