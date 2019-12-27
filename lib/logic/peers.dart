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
}

class PeerList {
  List<Peer> _peers = [];
  Connector _connector;

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
    var peer = findPeer(newMessage, remoteIp);
    if (peer == null) {
      addPeer(Peer.withPort(remoteIp, newMessage.listeningPort));
    } else {
      peer.incomingConnection = true;
    }
  }

  void lostPeer(StatusMessage lastMessage, String remoteIp) {
    ///with the last message recieved mark this peer as no longer connected
    findPeer(lastMessage, remoteIp).incomingConnection = false;
  }

  Peer findPeer(StatusMessage peerStatus, String remoteIp) {
    String incomingID = remoteIp + ':' + peerStatus.listeningPort.toString();
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
}
