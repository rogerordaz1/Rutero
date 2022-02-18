import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:reoruta/services/gps_service.dart';

import 'listen_location.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PermissionStatus? _permissionGranted;
  bool lights = false, _lights1 = false;
  final Location location = Location();
  bool? _serviceEnabled;

  @override
  void initState() {
    // _checkService();
    //  _checkPermissions();
    super.initState();
  }

  // Future<void> _checkService() async {
  //   final bool serviceEnabledResult = await location.serviceEnabled();
  //   setState(() {
  //     _serviceEnabled = serviceEnabledResult;
  //     if (_serviceEnabled == true) {
  //       lights = true;
  //     }
  //   });
  // }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled!) {
      final bool serviceRequestedResult = await location.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
        if (_serviceEnabled == false) {
          lights = false;
        }
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
      if (_permissionGranted == PermissionStatus.granted) {
        _lights1 = true;
      }
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
        if (_permissionGranted != PermissionStatus.granted) {
          _lights1 = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gpsService = Provider.of<GpsService>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.9),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(30, 7, 243, 0.8),
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 140,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 2)
            ],
          ),
          child: Column(
            children: <Widget>[
              const Text(
                'Instrucciones',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(244, 242, 250, 1),
                        spreadRadius: 2,
                        blurRadius: 2)
                  ],
                ),
                height: 80,
                width: MediaQuery.of(context).size.width * 0.85,
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Estado del Servicio'),
                  subtitle: (gpsService.isGpsEnabled)
                      ? const Text("servicio activado")
                      : const Text('Servicio desactivado'),
                  trailing: IconButton(
                    splashColor: Colors.blue,
                    onPressed: () {},
                    icon: (gpsService.isGpsEnabled)
                        ? const Icon(Icons.airplanemode_active_sharp)
                        : const Icon(Icons.airplanemode_inactive_sharp),
                  ),
                ),
              ),
              const Divider(height: 30),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(244, 242, 250, 1),
                        spreadRadius: 2,
                        blurRadius: 2)
                  ],
                ),
                height: 80,
                width: MediaQuery.of(context).size.width * 0.85,
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Estado del Permiso'),
                  subtitle: (gpsService.isGpsPermissionEnabled)
                      ? const Text("Permiso activado")
                      : const Text('Permiso desactivado'),
                  trailing: IconButton(
                    splashColor: Colors.blue,
                    onPressed: () {},
                    icon: (gpsService.isGpsPermissionEnabled)
                        ? const Icon(Icons.airplanemode_active_sharp)
                        : const Icon(Icons.airplanemode_inactive_sharp),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const ListenLocationWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
