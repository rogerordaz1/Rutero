import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reoruta/services/gps_service.dart';
import 'package:reoruta/services/location_provider.dart';

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key? key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  @override
  void dispose() {
    final locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.stopLocationStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gpsService = Provider.of<GpsService>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    return FutureBuilder(
      future: gpsService.isGpsPermission(),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Latitud en tiempo real es ${locationProvider.latitud} '),
            Text('Longitud en tiempo real es ${locationProvider.longitud} '),
            const Divider(
              height: 20,
            ),
            Center(
              child: (!gpsService.isGpsEnabled)
                  ? FloatingActionButton(
                      backgroundColor: Colors.grey,
                      child: const Text('OFF'),
                      onPressed: () => {},
                    )
                  : FloatingActionButton(
                      child: Image.asset(
                        'assets/logo_boton1.png',
                        scale: 5,
                      ),
                      onPressed: () async {
                        if (gpsService.isGpsPermissionEnabled &&
                            gpsService.isGpsPermissionBackGoundEnabled) {
                          locationProvider.getCurrentPosition();
                          locationProvider.startStreamLocation();
                          locationProvider.toggleBackgroundMode();
                        } else {
                          await gpsService.askGpsAccess();
                          locationProvider.toggleBackgroundMode();
                          locationProvider.startStreamLocation();
                        }
                      },
                    ),
            )
          ],
        );
      },
    );
  }
}
