import 'dart:io';
import 'dart:convert';

import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/status_message.dart';

class Connector {
  PeerList _peerList;
  List<Connection> _connections = <Connection>[];
  StatusMessage _templateMessage;

  Connector(PeerList peerList, StatusMessage templateMessage) {
    this._peerList = peerList;
    this._templateMessage = templateMessage;
    _peerList.connector = this;
  }

  startConnecting() {
    for (Peer peer in _peerList.peers) {
      addConnection(peer);
    }
  }

  addConnection(Peer peer) {
    _connections.add(Connection(peer, _templateMessage));
  }
}

class Connection {
  Peer _peer;
  StatusMessage _templateMessage;
  static const int _messageInterval = 2;
  static const int _maxBackoff = 30;

  Connection(Peer peer, StatusMessage templateMessage) {
    _peer = peer;
    _templateMessage = templateMessage;
    _startConnection();
  }

  Future<void> _startConnection() async {
    int backoff = 0;
    while (true) {
      Socket socket;
      try {
        print('trying to connect to ${_peer.host}');
        socket = await Socket.connect(_peer.host, _peer.port);
        backoff = 0;
        _peer.outgoingConnection = true;
        await _handleConnection(socket);
      } on SocketException catch (e) {
        print(e);
        await Future.delayed(Duration(seconds: backoff));
        if (backoff < _maxBackoff) {
          backoff += 5;
        }
      } finally {
        //TODO this needs to do some sort of notifyupdate
        _peer.outgoingConnection = false;
      }
    }
  }

  Future<void> _handleConnection(Socket socket) async {
    print('connected to ${_peer.peerID}');
    try {
      while (true) {
        var rawSend = jsonEncode(_templateMessage.toJson());
        print('sending $rawSend to ${socket.remoteAddress}');
        socket.write(rawSend);
        await socket.flush();
        await Future.delayed(Duration(seconds: _messageInterval));
      }
    } catch (e) {
      print(e);
    } finally {
      socket.close();
    }
  }
}
