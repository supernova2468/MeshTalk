import 'package:omsat_app/logic/peers.dart';

class StatusMessage {
  int listeningPort;

  StatusMessage(this.listeningPort);

  StatusMessage.fromJson(Map<String, dynamic> json) {
    listeningPort = json['listeningPort'];
  }

  Map<String, dynamic> toJson() {
    return {'listeningPort': listeningPort};
  }

  String toString() {
    return this.toJson().toString();
  }
}
