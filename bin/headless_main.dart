import 'package:omsat_app/logic/listener.dart';
import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/connector.dart';
import 'package:omsat_app/logic/status_message.dart';

main(List<String> arguments) {
  var listeningPort = int.parse(arguments[1]);

  // var uuid = Uuid().v4();
  var uuid = 'something_unique2';

  var myPeerList = PeerList();
  myPeerList.clientUUID = uuid;

  myPeerList.addPeer(Peer.withPort(arguments[0], Peer.defaultListeningPort));

  TcpListener(myPeerList, listeningPort).startListening();

  var templateMessage = StatusMessage(
      listeningPort, myPeerList, 'test peer on $listeningPort', uuid);

  templateMessage.location =
      LocationJsonable.fromCoordinates(37.2824, -121.8876);

  Connector(myPeerList, templateMessage).startConnecting();
}
