import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation_bar.dart';
import 'peers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PeerList()),
      ],
      child: MaterialApp(
        title: 'OMSAT',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: OmsatNavigationToolbar(),
      ),
    );
  }
}
