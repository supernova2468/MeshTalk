import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:omsat_app/ui/navigation_bar.dart';
import 'package:omsat_app/logic/peer_ui_wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PeerListUI()),
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
