import 'package:flutter/material.dart';
import 'dart:math';

class Peer {
  static final defaultListeningPort = 25578;
  String host;
  int port;
  bool outgoingConnection;
  bool incomingConnection;
  static var randGen = Random();

  Peer(hostIn) {
    host = hostIn;
    port = defaultListeningPort;
    outgoingConnection = randGen.nextBool();
    incomingConnection = randGen.nextBool();
  }
}

class PeerList with ChangeNotifier {
  List<Peer> _peers = [];

  void addPeer(Peer peer) {
    _peers.add(peer);
    notifyListeners();
  }

  List<Peer> get peers => _peers;
}
