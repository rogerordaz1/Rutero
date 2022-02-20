import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class GpsService extends ChangeNotifier {
  bool isGpsEnabled = false;
  bool isGpsPermissionEnabled = false;
  bool isGpsPermissionBackGoundEnabled = false;

  final location = loc.Location();

  StreamSubscription? gpsStatusSubscription;

  GpsService() {
    init();
  }

  Future<void> init() async {
    final isEnabled = await _checkGpsStatus();

    isGpsEnabled = isEnabled;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();

    gpsStatusSubscription = Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      isGpsEnabled = isEnabled;
      notifyListeners();
    });

    return isEnabled;
  }

  Future<void> isGpsPermission() async {
    final status = await Permission.location.status;
    final backstatus = await Permission.locationAlways.status;
    switch (status) {
      case PermissionStatus.granted:
        isGpsPermissionEnabled = true;
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        isGpsPermissionEnabled = false;
        notifyListeners();
    }
    switch (backstatus) {
      case PermissionStatus.granted:
        isGpsPermissionBackGoundEnabled = true;
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        isGpsPermissionBackGoundEnabled = false;
        notifyListeners();
    }
  }

  // Future<void> isGpsBackGoroundPermission() async {
  //   final status = await Permission.locationAlways.status;
  //   switch (status) {
  //     case PermissionStatus.granted:
  //       isGpsPermissionBackGoundEnabled = true;
  //       break;

  //     case PermissionStatus.denied:
  //     case PermissionStatus.restricted:
  //     case PermissionStatus.limited:
  //     case PermissionStatus.permanentlyDenied:
  //       isGpsPermissionBackGoundEnabled = false;
  //       notifyListeners();
  //   }
  // }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        isGpsPermissionEnabled = true;
        await Permission.locationAlways.request();
        notifyListeners();
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        isGpsPermissionEnabled = false;
        notifyListeners();
        openAppSettings();
    }
  }

  void stopgetServiceStatusStream() {
    gpsStatusSubscription?.cancel();
    notifyListeners();
  }
}
