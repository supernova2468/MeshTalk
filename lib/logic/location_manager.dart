import 'dart:async';

import 'package:location/location.dart';
import 'package:omsat_app/logic/peers.dart';
import 'package:omsat_app/logic/status_message.dart';

class LocationManager {
  LocationData currentLocation;
  StatusMessage templateMessage;
  StreamSubscription _locationSubscription;

  LocationManager(this.templateMessage);

  locationUpdateHandler(LocationData currentLocation) {
    ///take the callback from the location update and manage it here
    this.currentLocation = currentLocation;
    var newLocation = LocationJsonable.fromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    this.templateMessage.location = newLocation;
    notifyListenersWrapper();
  }

  void startTracking() {
    var locationService = new Location();
    _locationSubscription = locationService.onLocationChanged().listen(
        (LocationData currentLocation) =>
            locationUpdateHandler(currentLocation));
  }

  void stopTracking() {
    _locationSubscription.cancel();
  }

  void notifyListenersWrapper() {}
}
