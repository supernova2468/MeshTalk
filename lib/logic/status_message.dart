import 'package:omsat_app/logic/peers.dart';

class StatusMessage {
  int listeningPort;
  PeerList peerList;
  String name;
  String uuid;
  LocationJsonable location;

  StatusMessage(this.listeningPort, this.peerList, this.name, this.uuid);

  StatusMessage.limitedValues(this.listeningPort, this.peerList) {
    /// build a status message only with the always known values
  }

  StatusMessage.fromJson(Map<String, dynamic> json) {
    listeningPort = json['listeningPort'];
    peerList = PeerList.fromJson(json['peerList']);
    name = json['name'];
    uuid = json['uuid'];
    location = LocationJsonable.fromJson(json['location']);
  }

  Map<String, dynamic> toJson() {
    return {
      'listeningPort': listeningPort,
      'peerList': peerList,
      'name': name,
      'uuid': uuid,
      'location': location,
    };
  }

  String toString() {
    return this.toJson().toString();
  }
}
