import 'package:flutter/material.dart';
import 'package:omsat_app/logic/peers.dart';

class PeerListUI extends PeerList with ChangeNotifier {
  @override
  void addPeer(Peer peer) {
    super.addPeer(peer);
    notifyListeners();
  }
}
