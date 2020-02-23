import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:omsat_app/ui/group_view.dart';
import 'package:omsat_app/ui/peers_view.dart';
import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/peer_ui_wrapper.dart';
import 'package:omsat_app/ui/main_appbar.dart';

class OmsatMainScaffold extends StatefulWidget {
  @override
  _OmsatMainScaffoldState createState() => _OmsatMainScaffoldState();
}

class _OmsatMainScaffoldState extends State<OmsatMainScaffold> {
  int _selectedIndex = 1;
  bool _fabVisible = true;
  TextEditingController _newPeerField = TextEditingController();

  static List<Widget> _widgetOptions = <Widget>[
    GroupViewWidget(),
    PeerViewWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _fabVisible = true;
      } else {
        _fabVisible = false;
      }
    });
  }

  Future<void> _addNewPeerDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Manually Add Peer'),
          content: TextField(
            controller: _newPeerField,
            decoration: InputDecoration(labelText: 'Hostname or IP address'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                Provider.of<PeerListUI>(context, listen: false)
                    .addPeer(Peer(_newPeerField.text));
                _newPeerField.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: OmsatMainAppBar(),
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
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            onPressed: () => _addNewPeerDialog(),
            child: Icon(Icons.add),
          ),
          visible: _fabVisible,
        ));
  }
}
