import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

class LocationProvider extends ChangeNotifier {
  bool followingUser = false;
  String latitud = '';
  String longitud = '';
  String accuracy = '';
  StreamSubscription? gpsStatusSubscription;
  var url = Uri.parse('http://78.108.216.56:1337/ubicacions');
  // Location location = Location();

  Future getCurrentPosition() async {
    final locationData = await Location.instance.getLocation();
    print("position :${locationData}");
    notifyListeners();
  }

  void startStreamLocation() {
    Location.instance.changeSettings(accuracy: LocationAccuracy.navigation);
    gpsStatusSubscription =
        Location.instance.onLocationChanged.handleError((dynamic err) {
      print("El error del Stream es: $err");
      gpsStatusSubscription?.cancel();
    }).listen((LocationData currentLocation) {
      latitud = currentLocation.latitude.toString();
      longitud = currentLocation.longitude.toString();
      accuracy = currentLocation.accuracy.toString();
      notifyListeners();
      sendToApi();

      print('enento :$currentLocation');
      print('Latitud :$latitud');
      print('Longitud :$longitud');
      print('Accuracy :$accuracy');
    });
    Location.instance.changeNotificationOptions(
      title: "Localización en segundo plano Activada",
    );
  }

  void stopLocationStream() {
    gpsStatusSubscription?.cancel();
    notifyListeners();
  }

  void sendToApi() async {
    await http.post(url, body: {
      'imei': '4',
      'ubicacion': '$latitud,$longitud*${accuracy.toString()}',
      'ip': ''
    });
  }

  Future<void> toggleBackgroundMode() async {
    try {
      final bool result =
          await Location.instance.enableBackgroundMode(enable: true);
    } catch (err) {
      print(err);
    }
  }
}
