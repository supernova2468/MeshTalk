import 'package:omsat_app/logic/peers.dart';

class StatusMessage {
  int listeningPort;
  PeerList peerList;
  String name;

  StatusMessage(this.listeningPort, this.peerList, this.name);

  StatusMessage.fromJson(Map<String, dynamic> json) {
    listeningPort = json['listeningPort'];
    peerList = PeerList.fromJson(json['peerList']);
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'listeningPort': listeningPort,
      'peerList': peerList,
      'name': name,
    };
  }

  String toString() {
    return this.toJson().toString();
  }
}
