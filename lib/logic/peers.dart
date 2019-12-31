import 'dart:ffi';

import 'package:omsat_app/logic/status_message.dart';
import 'package:omsat_app/logic/connector.dart';

class Peer {
  static final defaultListeningPort = 25578;
  String host;
  int port; //listening port of remote peer
  bool _outgoingConnection = false; //this client is connected out
  bool incomingConnection = false; //that client is connected in
  PeerList parentListUI; //if there is a ui capture that peerlist
  String name = 'Unknown Peer';
  String uuid;

  Peer(String hostIn) {
    this.host = hostIn;
    this.port = defaultListeningPort;
  }

  Peer.withPort(hostIn, int portIn) {
    this.host = hostIn;
    this.port = portIn;
  }

  Peer.fromMessage(hostIn, StatusMessage message) {
    this.host = hostIn;
    this.port = message.listeningPort;
    this.name = message.name;
    this.uuid = message.uuid;
  }

  bool get outgoingConnection => _outgoingConnection;

  set outgoingConnection(bool value) {
    //wrap the outgoing connection so that the ui can be updated when in ui mode
    _outgoingConnection = value;
    if (parentListUI != null) parentListUI.notifyListenersWrapper();
  }

  Map<String, dynamic> toJson() {
    /// create json for the status_message
    return {
      'host': host,
      'port': port,
      'name': name,
      'uuid': uuid,
    };
  }

  String toString() {
    return this.toJson().toString();
  }

  Peer.fromJson(Map<String, dynamic> json) {
    /// pull in json values that are transferable
    host = json['host'];
    port = json['port'];
    name = json['name'];
    uuid = json['uuid'];
  }
}

class PeerList {
  List<Peer> _peers;
  Connector _connector;
  String clientUUID;

  PeerList() {
    _peers = [];
  }

  void addPeer(Peer peer, {bool ignoreDuplicate = false}) {
    if (!ignoreDuplicate) {
      if (this.clientUUID == null) {
        throw new Exception('no peerlist uuid set');
      }
      for (var existingPeer in _peers) {
        if (existingPeer.uuid != null && existingPeer.uuid == peer.uuid) {
          throw new Exception('duplicate peer uuid');
        }
      }
    }
    if (!ignoreDuplicate || peer.uuid != clientUUID) {
      _peers.add(peer);
      if (_connector != null) {
        _connector.addConnection(peer);
      }
    }
    notifyListenersWrapper();
  }

  void addUpdatePeers(StatusMessage newMessage, String remoteIp) {
    ///takes a status message and the remoteIpAddress updates the peer
    ///if existing or creates a new one
    var peer = findPeer(newMessage.uuid);

    if (peer == null) {
      peer = Peer.fromMessage(remoteIp, newMessage);
      addPeer(peer);
    } else {
      //data we only fill when receiving from a message is filled here
      peer.name = newMessage.name;
      peer.uuid = newMessage.uuid;
    }
    peer.incomingConnection = true;

    //merge in the list of peers from the message, in the future
    // a web of trust could be added here
    mergeInPeerList(newMessage.peerList);

    // update ui (if there is one)
    notifyListenersWrapper();
  }

  void mergeInPeerList(PeerList peerListIn) {
    ///merge in an existing peer list
    ///generally from a message or saved preferences
    for (Peer incomingPeer in peerListIn.peers) {
      // don't add peers that are lacking basic info
      if (incomingPeer.uuid == null || incomingPeer.uuid == 'null') {
        break;
      }
      // don't add duplicates
      if (findPeer(incomingPeer.uuid) != null) {
        break;
      }

      this.addPeer(incomingPeer);
    }
  }

  void lostPeer(StatusMessage lastMessage) {
    ///with the last message recieved mark this peer as no longer connected
    findPeer(lastMessage.uuid).incomingConnection = false;
    notifyListenersWrapper();
  }

  Peer findPeer(String uuidIn) {
    Peer foundPeer;
    for (var peer in _peers) {
      if (peer.uuid == uuidIn) {
        foundPeer = peer;
      }
    }
    return foundPeer;
  }

  List<Peer> get peers => _peers;

  set connector(Connector connector) {
    _connector = connector;
  }

  Map<String, dynamic> toJson() {
    return {
      '_peers': _peers,
    };
  }

  String toString() {
    return this.toJson().toString();
  }

  PeerList.fromJson(Map<String, dynamic> json) {
    var peerList = <Peer>[];
    for (var peerJson in json['_peers']) {
      peerList.add(Peer.fromJson(peerJson));
    }
    _peers = peerList;
  }

  void notifyListenersWrapper() {
    // do nothing when not in ui
  }
}
