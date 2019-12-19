import 'package:flutter/material.dart';

import 'group_view.dart';
import 'peers_view.dart';

class OmsatNavigationToolbar extends StatefulWidget {
  OmsatNavigationToolbar({Key key}) : super(key: key);

  @override
  _OmsatNavigationToolbarState createState() => _OmsatNavigationToolbarState();
}

class _OmsatNavigationToolbarState extends State<OmsatNavigationToolbar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    GroupViewWidget(),
    PeerViewWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('OMSAT App'),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Group'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              title: Text('Peers'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => print('pressed'),
          child: Icon(Icons.add),
        ));
  }
}
