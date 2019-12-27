import 'package:omsat_app/logic/listener.dart';
import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/connector.dart';
import 'package:omsat_app/logic/status_message.dart';

main(List<String> arguments) {
  var listeningPort = int.parse(arguments[0]);

  var myPeerList = PeerList();

  myPeerList.addPeer(Peer.withPort('192.168.1.77', Peer.defaultListeningPort));

  TcpListener(myPeerList, listeningPort).startListening();

  var templateMessage = StatusMessage(listeningPort, myPeerList);

  Connector(myPeerList, templateMessage).startConnecting();
}
