import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:omsat_app/logic/peers.dart';

class TcpListener {
  PeerList _peerList;
  int _port;
  int _connectionCounter = 0;

  TcpListener(PeerList peerList, int port) {
    _peerList = peerList;
    _port = port;
  }

  Future<void> startListening() async {
    ServerSocket serverSocket =
        await ServerSocket.bind('0.0.0.0', this._port, shared: true);
    //spin off a connection handler for each incoming connection
    serverSocket.listen((Socket socket) => handleConnection(socket));
  }

  Future<void> handleConnection(Socket socket) async {
    _connectionCounter += 1;
    var localConnection = _connectionCounter;
    print('connection $localConnection from ${socket.remoteAddress.host}');
    Uint8List dataChunk;
    await for (var data in socket) {
      dataChunk.addAll(data);

      if (data.length == 0) break;
      print(utf8.decode(data));
    }
    print('connection $localConnection lost');
  }
}
