import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:preferences/preferences.dart';

import 'package:omsat_app/ui/navigation_bar.dart';
import 'package:omsat_app/logic/peer_ui_wrapper.dart';
import 'package:omsat_app/logic/listener.dart';
import 'package:omsat_app/logic/connector.dart';
import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/status_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final peerList = PeerListUI();
  static final templateMessage =
      StatusMessage.limitedValues(Peer.defaultListeningPort, peerList);

  static loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // uuid needs to be first in order to add peers correctly
    var uuid = prefs.getString('uuid');
    if (uuid == null) {
      uuid = Uuid().v4();
      prefs.setString('uuid', uuid);
    }
    templateMessage.uuid = uuid;
    peerList.clientUUID = uuid;

    var peerListString = prefs.getString('peerList');
    if (peerListString != null) {
      var prefPeerList = PeerList.fromJson(jsonDecode(peerListString));
      peerList.mergeInPeerList(prefPeerList);
      // save the peer list back now that it has been purged of bad peers
      prefs.setString('peerList', jsonEncode(peerList.toJson()));
    }

    //name
    var name = prefs.getString('pref_name');
    if (name == null) {
      name = 'No Name';
    }
    templateMessage.name = name;
  }

  @override
  Widget build(BuildContext context) {
    TcpListener(peerList, Peer.defaultListeningPort).startListening();
    Connector(peerList, templateMessage).startConnecting();

    loadPreferences();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => peerList),
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
