import 'dart:io';

import 'package:omsat_app/logic/listener.dart';
import 'package:omsat_app/logic/peers.dart';

main() async {
  var myPeerList = PeerList();
  print('Hostname or IP');
  String hostname = stdin.readLineSync();
  print('Port');
  String port = stdin.readLineSync();
  var portInt = int.parse(port);

  myPeerList.addPeer(Peer.withPort(hostname, portInt));

  await TcpListener(myPeerList, 12345).startListening();
}
