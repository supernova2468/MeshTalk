import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/peer_ui_wrapper.dart';
import 'package:omsat_app/logic/location_manager_ui_wrapper.dart';

class PeerViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PeerListUI>(builder: (_, peerList, __) {
      return ListView.builder(
        itemCount: peerList.peers.length,
        itemBuilder: (_, int index) {
          return PeerCard(peerList.peers[index]);
        },
        //separatorBuilder: (_, __) => Divider(),
      );
    });
  }
}

class PeerCard extends StatelessWidget {
  final Peer peer;

  PeerCard(this.peer);

  static Color _getIconColor(Peer peer) {
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
          color = Colors.green;
          break;
        }

      default:
        {
          color = Colors.grey[300];
        }
    }

    return color;
  }

  static String _getDistanceDescriptor(
      LocationJsonable peerLocation, LocationData myLocation) {
    // this is really simplistic and will be wrong at any meaningful distance
    // need a fancier formula haversine or something
    try {
      var latDiff = myLocation.latitude - peerLocation.latitude;
      var lonDiff = myLocation.longitude - peerLocation.longitude;
      double earthRadius = 3958.8;
      double distanceFeet =
          earthRadius * math.sqrt(math.pow(latDiff, 2) + math.pow(lonDiff, 2));
      return '${distanceFeet.abs().round()} ft';
    } catch (e) {
      print('distance calc error: $e');
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.public,
              color: _getIconColor(peer),
            ),
            title: Text('${peer.name}'),
            subtitle: Text('${peer.host}:${peer.port}'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9.0, bottom: 9.0),
            child: Column(
              children: <Widget>[
                PeerDataRow(Icons.call_made,
                    'Outgoing Connection: ${peer.outgoingConnection}'),
                PeerDataRow(Icons.call_received,
                    'Incoming Connection: ${peer.incomingConnection}'),
                PeerDataRow(Icons.account_circle, 'UUID: ${peer.uuid}'),
                PeerDataRow(Icons.gps_fixed,
                    'Location: ${peer.location.latitude}, ${peer.location.longitude}'),
                Consumer<LocationManagerUI>(
                  builder: (_, locationManager, __) => PeerDataRow(
                      Icons.track_changes,
                      'Distance: ${_getDistanceDescriptor(peer.location, locationManager.currentLocation)}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PeerDataRow extends StatelessWidget {
  final IconData icon;
  final String text;

  PeerDataRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 10,
        ),
        Text(' ' + text),
      ],
    );
  }
}
