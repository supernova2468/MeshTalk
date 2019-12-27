import 'package:omsat_app/logic/status_message.dart';
import 'package:omsat_app/logic/connector.dart';

class Peer {
  static final defaultListeningPort = 25578;
  String host;
  int port; //listening port of remote peer
  bool outgoingConnection = false; //this client is connected out
  bool incomingConnection = false; //that client is connected in

  Peer(hostIn) {
    host = hostIn;
    port = defaultListeningPort;
  }

  Peer.withPort(hostIn, int portIn) {
    host = hostIn;
    port = portIn;
  }

  // this should be unique
  String get peerID => host + ':' + port.toString();

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'port': port,
      'outgoingConnection': outgoingConnection,
      'incomingConnection': incomingConnection,
    };
  }

  String toString() {
    return this.toJson().toString();
  }

  Peer.fromJson(Map<String, dynamic> json) {
    host = json['host'];
    port = json['port'];
  }
}

class PeerList {
  List<Peer> _peers;
  Connector _connector;

  PeerList() {
    _peers = [];
  }

  void addPeer(Peer peer) {
    for (var existingPeer in _peers) {
      if (existingPeer.peerID == peer.peerID) {
        throw new Exception('duplicate peer host port combo');
      }
    }
    if (_connector != null) {
      _connector.addConnection(peer);
    }
    _peers.add(peer);
  }

  void addUpdatePeers(StatusMessage newMessage, String remoteIp) {
    ///takes a status message and the remoteIpAddress updates the peer
    ///if existing or creates a new one
    var peer = findPeer(remoteIp, newMessage.listeningPort);
    if (peer == null) {
      addPeer(Peer.withPort(remoteIp, newMessage.listeningPort));
    } else {
      peer.incomingConnection = true;
    }
    for (Peer incomingPeer in newMessage.peerList.peers) {
      if (findPeer(incomingPeer.host, incomingPeer.port) == null) {
        this.addPeer(incomingPeer);
        //TODO need to not add the localhost
      }
    }
  }

  void lostPeer(StatusMessage lastMessage, String remoteIp) {
    ///with the last message recieved mark this peer as no longer connected
    findPeer(remoteIp, lastMessage.listeningPort).incomingConnection = false;
  }

  Peer findPeer(String remoteIp, int listeningPort) {
    String incomingID = remoteIp + ':' + listeningPort.toString();
    Peer foundPeer;
    for (var peer in _peers) {
      if (peer.peerID == incomingID) {
        foundPeer = peer;
        print('found peer');
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
}
