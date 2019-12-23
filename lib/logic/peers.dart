import 'dart:math';

class Peer {
  static final defaultListeningPort = 25578;
  String host;
  int port; //listening port of remote peer
  bool outgoingConnection = false; //this client is connected out
  bool incomingConnection = false; //that client is connected in
  static var randGen = Random();

  Peer(hostIn) {
    host = hostIn;
    port = defaultListeningPort;
    outgoingConnection = randGen.nextBool();
    incomingConnection = randGen.nextBool();
  }

  Peer.withPort(hostIn, int portIn) {
    host = hostIn;
    port = portIn;
  }

  // this should be unique
  String get peerID => host + port.toString();
}

class PeerList {
  List<Peer> _peers = [];

  void addPeer(Peer peer) {
    for (var existingPeer in _peers) {
      if (existingPeer.peerID == peer.peerID) {
        throw new Exception('duplicate peer host port combo');
      }
    }
    _peers.add(peer);
  }

  List<Peer> get peers => _peers;

  Future<void> startConnecting() async {
    ///work over list of peers and try to connect to each of them
  }
}
