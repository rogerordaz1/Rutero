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
  final Location location = Location();

  @override
  void dispose() {
    final gpsService = Provider.of<GpsService>(context);
    gpsService.stopgetServiceStatusStream();

    super.dispose();
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
                child: FutureBuilder(
                  future: gpsService.init(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Estado del Servicio'),
                      subtitle: (gpsService.isGpsEnabled)
                          ? const Text("servicio activado")
                          : const Text('Servicio desactivado'),
                      trailing: IconButton(
                        splashColor: Colors.blue,
                        onPressed: (gpsService.isGpsEnabled) ? () {} : () {},
                        icon: (gpsService.isGpsEnabled)
                            ? const Icon(Icons.airplanemode_active_sharp)
                            : const Icon(Icons.airplanemode_inactive_sharp),
                      ),
                    );
                  },
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
                child: FutureBuilder(
                  future: gpsService.isGpsPermission(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Estado del Permiso'),
                      subtitle: (gpsService.isGpsPermissionEnabled)
                          ? const Text("Permiso activado")
                          : const Text('Permiso desactivado'),
                      trailing: IconButton(
                        splashColor: Colors.blue,
                        onPressed: () {
                          gpsService.askGpsAccess();
                        },
                        icon: (gpsService.isGpsPermissionEnabled)
                            ? const Icon(Icons.airplanemode_active_sharp)
                            : const Icon(Icons.airplanemode_inactive_sharp),
                      ),
                    );
                  },
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
                height: 100,
                width: MediaQuery.of(context).size.width * 0.85,
                child: FutureBuilder(
                  future: gpsService.isGpsPermission(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: Text("Estado de la Ubicacion")),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                              'Segundo Plano : ${gpsService.isGpsPermissionBackGoundEnabled}',
                              style: const TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                              "Primer Plano : ${gpsService.isGpsPermissionEnabled}",
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ],
                    );
                  },
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
