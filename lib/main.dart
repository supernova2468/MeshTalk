import 'package:flutter/material.dart';
import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/status_message.dart';
import 'package:provider/provider.dart';

import 'package:omsat_app/ui/navigation_bar.dart';
import 'package:omsat_app/logic/peer_ui_wrapper.dart';
import 'package:omsat_app/logic/listener.dart';
import 'package:omsat_app/logic/connector.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final peerList = PeerListUI();

  @override
  Widget build(BuildContext context) {
    TcpListener(peerList, Peer.defaultListeningPort).startListening();
    var templateMessage = StatusMessage(Peer.defaultListeningPort, peerList);
    Connector(peerList, templateMessage).startConnecting();

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
