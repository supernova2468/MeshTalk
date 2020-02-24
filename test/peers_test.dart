import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/status_message.dart';

class MockPeerList extends Mock implements PeerList {}

void main() {
  group('LocationJsonable', () {
    test('will be json serializable', () {
      final locationJsonable =
          LocationJsonable.fromCoordinates(123.456, 789.10);

      expect(jsonEncode(locationJsonable.toJson()),
          '{"latitude":123.456,"longitude":789.1}');
    });

    group('can be created from json', () {
      LocationJsonable locationJsonable;
      setUp(() {
        final locationString = '{"latitude":123.456,"longitude":789.1}';

        locationJsonable =
            LocationJsonable.fromJson(jsonDecode(locationString));
      });

      test('latitude', () {
        expect(locationJsonable.latitude, 123.456);
      });

      test('longitude', () {
        expect(locationJsonable.longitude, 789.1);
      });
    });
  });

  group('Peer', () {
    test('will be json serializable', () {
      var peer = Peer('dummy_host');
      peer.uuid = '12345';
      var jsonPeer = jsonEncode(peer.toJson());
      expect(jsonPeer,
          '{"host":"dummy_host","port":25578,"name":"Unknown Peer","uuid":"12345"}');
    });
    group('can be created from json', () {
      Peer peer;
      setUp(() {
        var peerString =
            '{"host":"dummy_host","port":28798,"name":"known peer","uuid":"12345"}';
        peer = Peer.fromJson(jsonDecode(peerString));
      });

      test('host', () {
        expect(peer.host, 'dummy_host');
      });
      test('port', () {
        expect(peer.port, 28798);
      });
      test('name', () {
        expect(peer.name, 'known peer');
      });
      test('uuid', () {
        expect(peer.uuid, '12345');
      });
    });

    group('can be created from status message', () {
      Peer peer;
      setUp(() {
        var statusMessage = StatusMessage(1592, null, 'a name', 'unique id');
        peer = Peer.fromMessage('dummy host', statusMessage);
      });

      test('host', () {
        expect(peer.host, 'dummy host');
      });
      test('port', () {
        expect(peer.port, 1592);
      });
      test('name', () {
        expect(peer.name, 'a name');
      });
      test('uuid', () {
        expect(peer.uuid, 'unique id');
      });
    });

    test('will update the ui listeners when outgoing connection is updated',
        () {
      var peerListUI = MockPeerList();
      var peer = Peer('some host');
      peer.parentListUI = peerListUI;
      peer.outgoingConnection = true;

      verify(peerListUI.notifyListenersWrapper());
    });
  });
}
