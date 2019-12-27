import 'dart:io';
import 'dart:convert';

import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/status_message.dart';

class TcpListener {
  PeerList _peerList;
  int _port;

  TcpListener(PeerList peerList, int port) {
    _peerList = peerList;
    _port = port;
  }

  Future<void> startListening() async {
    ServerSocket serverSocket =
        await ServerSocket.bind('0.0.0.0', this._port, shared: true);
    //spin off a connection handler for each incoming connection
    serverSocket.listen((Socket socket) => TcpConnection(socket, _peerList));
  }
}

class TcpConnection {
  Socket _socket;
  PeerList _peerList;
  static int _connectionCount = 0;
  int _localConnectionCount;
  StatusMessage _lastMessageReceived;

  TcpConnection(Socket socket, PeerList peerList) {
    this._socket = socket;
    this._peerList = peerList;

    _connectionCount += 1;
    _localConnectionCount = _connectionCount;
    print(
        'connection $_localConnectionCount from ${_socket.remoteAddress.host}');

    var decodedStream = Utf8Decoder().bind(socket);
    // var decodedStream = JsonDecoder().bind(Utf8Decoder().bind(socket));
    decodedStream.listen(_onData, onDone: _onDone, onError: _onError);
  }

  void _onData(String data) {
    print('got raw data: $data');
    String remainStr = data;
    //always see if there could be at least one json with a starting { and ending }
    while (remainStr.contains('{') &&
        remainStr.contains('}', remainStr.indexOf('{'))) {
      int jsonStart = remainStr.indexOf('{');
      int jsonEnd = remainStr.indexOf('}') + 1;
      String nextJsonStr = remainStr.substring(jsonStart, jsonEnd);
      //handle bad json and wrong json
      try {
        var newMessage = StatusMessage.fromJson(jsonDecode(nextJsonStr));
        print('got data: $newMessage');
        _lastMessageReceived = newMessage;
        _peerList.addUpdatePeers(newMessage, _socket.remoteAddress.host);
      } on FormatException catch (e) {
        print(e);
      } finally {
        remainStr = remainStr.substring(jsonEnd);
      }
    }
  }

  void _onDone() {
    print('connection $_localConnectionCount lost');
    _peerList.lostPeer(_lastMessageReceived, _socket.remoteAddress.host);
  }

  void _onError(var e) {
    print('error: $e');
  }
}
