import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reoruta/services/gps_service.dart';
import 'package:reoruta/services/location_provider.dart';
import 'Pages/home_page.dart';

void main() async {
  //Provider.debugCheckInvalidValueType = null;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<GpsService>(
        create: (_) => GpsService(),
        lazy: false,
      ),
      ChangeNotifierProvider<LocationProvider>(
        create: (_) => LocationProvider(),
        lazy: false,
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoRuta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GeoRuta'),
    );
  }
}
