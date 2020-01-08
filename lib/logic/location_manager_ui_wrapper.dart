import 'package:flutter/material.dart';

import 'package:omsat_app/logic/location_manager.dart';
import 'package:omsat_app/logic/status_message.dart';

class LocationManagerUI extends LocationManager with ChangeNotifier {
  LocationManagerUI(StatusMessage templateMessage) : super(templateMessage);

  @override
  void notifyListenersWrapper() {
    notifyListeners();
  }
}
