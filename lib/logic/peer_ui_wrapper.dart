import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:omsat_app/logic/peers.dart';

class PeerListUI extends PeerList with ChangeNotifier {
  @override
  void addPeer(Peer peer, {bool ignoreDuplicate = false}) {
    super.addPeer(peer, ignoreDuplicate: ignoreDuplicate);
    updateSavedPeers(peer);
  }

  Future<void> updateSavedPeers(Peer peer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var peerListString = prefs.getString('peerList');
    PeerList prefPeerList;
    if (peerListString == null) {
      prefPeerList = PeerList();
    } else {
      prefPeerList = PeerList.fromJson(jsonDecode(peerListString));
    }
    prefPeerList.addPeer(peer, ignoreDuplicate: true);
    var updatedPeerListString = prefPeerList.toJson();
    prefs.setString('peerList', jsonEncode(updatedPeerListString));
  }

  @override
  notifyListenersWrapper() {
    notifyListeners();
  }
}
