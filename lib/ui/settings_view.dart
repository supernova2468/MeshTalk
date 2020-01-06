import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

import 'package:omsat_app/main.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              MyApp.loadPreferences();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('Settings'),
      ),
      body: PreferencePage([
        PreferenceTitle('Profile'),
        TextFieldPreference('Name', 'name'),
      ]),
    );
  }
}
