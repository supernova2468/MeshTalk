import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'package:omsat_app/ui/settings_view.dart';
import 'package:omsat_app/logic/location_manager_ui_wrapper.dart';

class OmsatMainAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _OmsatMainAppBarState createState() => _OmsatMainAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _OmsatMainAppBarState extends State<OmsatMainAppBar> {
  IconData _gpsStateIcon = Icons.gps_off;

  void _onGpsTapped() {
    setState(() {
      if (_gpsStateIcon == Icons.gps_off) {
        Provider.of<LocationManagerUI>(context, listen: false).startTracking();
        Wakelock.enable();
        _gpsStateIcon = Icons.gps_fixed;
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('GPS Tracking Enabled'),
        ));
      } else {
        Provider.of<LocationManagerUI>(context, listen: false).stopTracking();
        Wakelock.disable();
        _gpsStateIcon = Icons.gps_off;
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('GPS Tracking Disabled'),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
