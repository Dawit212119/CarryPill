import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Holds the latest device Position app-wide; call notifyListeners after
// reassigning `position` to refresh dependent widgets.
class ProviderLocation extends ChangeNotifier {
  Position? position;
  ProviderLocation({
    this.position,
  });
}
