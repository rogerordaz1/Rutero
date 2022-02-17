import 'package:location_web/location_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins(Registrar registrar) {
  LocationWebPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
