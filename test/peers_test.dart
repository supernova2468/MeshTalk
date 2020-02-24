import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:omsat_app/logic/peers.dart';

void main() {
  group('LocationJsonable', () {
    test('will be json serializable', () {
      final locationJsonable =
          LocationJsonable.fromCoordinates(123.456, 789.10);

      expect(jsonEncode(locationJsonable.toJson()),
          '{"latitude":123.456,"longitude":789.1}');
    });

    test('can be created from json', () {
      final locationString = '{"latitude":123.456,"longitude":789.1}';

      final locationJsonable =
          LocationJsonable.fromJson(jsonDecode(locationString));

      expect(locationJsonable.latitude, 123.456);
      expect(locationJsonable.longitude, 789.1);
    });
  });
}
