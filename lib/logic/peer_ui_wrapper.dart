import 'package:flutter/material.dart';

import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/status_message.dart';

class PeerListUI extends PeerList with ChangeNotifier {
  @override
  void addPeer(Peer peer) {
    super.addPeer(peer);
    notifyListeners();
  }

  @override
  void addUpdatePeers(StatusMessage newMessage, String remoteIp) {
    super.addUpdatePeers(newMessage, remoteIp);
    notifyListeners();
  }

  @override
  void lostPeer(StatusMessage lastMessage, String remoteIp) {
    super.lostPeer(lastMessage, remoteIp);
    notifyListeners();
  }
}
