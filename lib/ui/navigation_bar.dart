import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:omsat_app/ui/group_view.dart';
import 'package:omsat_app/ui/peers_view.dart';
import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/peer_ui_wrapper.dart';
import 'package:omsat_app/ui/settings_view.dart';
import 'package:omsat_app/logic/location_manager_ui_wrapper.dart';

class OmsatNavigationToolbar extends StatefulWidget {
  @override
  _OmsatNavigationToolbarState createState() => _OmsatNavigationToolbarState();
}

class _OmsatNavigationToolbarState extends State<OmsatNavigationToolbar> {
  int _selectedIndex = 1;
  bool _fabVisible = true;
  TextEditingController _newPeerField = TextEditingController();
  IconData _gpsStateIcon = Icons.gps_off;

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

  void _onGpsTapped() {
    setState(() {
      if (_gpsStateIcon == Icons.gps_off) {
        Provider.of<LocationManagerUI>(context, listen: false).startTracking();
        Wakelock.enable();
        _gpsStateIcon = Icons.gps_fixed;
      } else {
        Provider.of<LocationManagerUI>(context, listen: false).stopTracking();
        Wakelock.disable();
        _gpsStateIcon = Icons.gps_off;
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
        appBar: AppBar(
          title: const Text('OMSAT App'),
          actions: <Widget>[
            IconButton(
              onPressed: _onGpsTapped,
              icon: Icon(_gpsStateIcon),
            ),
            IconButton(
              onPressed: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SettingsView())),
              icon: Icon(Icons.settings_applications),
            ),
          ],
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
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            onPressed: () => _addNewPeerDialog(),
            child: Icon(Icons.add),
          ),
          visible: _fabVisible,
        ));
  }
}
