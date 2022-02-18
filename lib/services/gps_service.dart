import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class GpsService extends ChangeNotifier {
  bool isGpsEnabled = false;
  bool isGpsPermissionEnabled = false;

  StreamSubscription<ServiceStatus>? gpsStatus;

  GpsService() {
    _init();
    notifyListeners();
  }

  Future<void> _init() async {
    final isEnabled = await _checkGpsStatus();
    isGpsEnabled = isEnabled;
    print(isEnabled);
  }

  Future<bool> _checkGpsStatus() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();

    gpsStatus = Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      print('Service status $isEnabled');
      // TODO: disarar eventos...
      isGpsEnabled = isEnabled;
      print("isGpsEnabled: $isGpsEnabled");
      notifyListeners();
    });

    return isEnabled;
  }

  // Future<void> close() {
  //   return super.close();
  // }

}
