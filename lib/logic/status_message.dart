import 'package:omsat_app/logic/peers.dart';

class StatusMessage {
  int listeningPort;
  PeerList peerList;

  StatusMessage(this.listeningPort, this.peerList);

  StatusMessage.fromJson(Map<String, dynamic> json) {
    listeningPort = json['listeningPort'];
    peerList = PeerList.fromJson(json['peerList']);
  }

  Map<String, dynamic> toJson() {
    return {
      'listeningPort': listeningPort,
      'peerList': peerList,
    };
  }

  String toString() {
    return this.toJson().toString();
  }
}
