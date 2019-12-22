import 'package:flutter/material.dart';
import 'package:omsat_app/peers.dart';
import 'package:provider/provider.dart';

class PeerViewWidget extends StatelessWidget {
  Color _getIconColor(Peer peer) {
    var totalState = 0;
    if (peer.incomingConnection) totalState += 1;
    if (peer.outgoingConnection) totalState += 1;

    Color color;
    switch (totalState) {
      case (1):
        {
          color = Colors.orange[200];
          break;
        }

      case (2):
        {
          color = Colors.orange;
          break;
        }

      default:
        {
          color = Colors.grey[300];
        }
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeerList>(builder: (_, peerList, __) {
      return ListView.separated(
        itemCount: peerList.peers.length,
        itemBuilder: (_, int index) {
          return ListTile(
            leading: Icon(
              Icons.public,
              color: _getIconColor(peerList.peers[index]),
            ),
            title: Text(peerList.peers[index].host),
            //subtitle: Text(peerList.peers[index].port.toString()),
          );
        },
        separatorBuilder: (_, __) => Divider(),
      );
    });
  }
}
