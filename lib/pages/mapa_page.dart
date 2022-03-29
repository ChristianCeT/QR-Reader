import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  //controlador de google maps
  final Completer<GoogleMapController> _controller = Completer();

  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    //posicion de la camara al momento de abrir la app
    final CameraPosition puntoInicial =
        CameraPosition(target: scan.getLatLng(), zoom: 17.5, tilt: 50);

    //marcadores
    Set<Marker> markers = <Marker>{};
    markers.add(
      Marker(
          markerId: const MarkerId('geo-location'), position: scan.getLatLng()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
        actions: [
          IconButton(
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: scan.getLatLng(), zoom: 17, tilt: 50),
                ));
              },
              icon: const Icon(Icons.location_searching_sharp))
        ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        mapType: mapType,
        markers: markers,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mapType == MapType.normal) {
            mapType = MapType.satellite;
          } else {
            mapType = MapType.normal;
          }
          //redibuja el widget
          setState(() {});
        },
        child: const Icon(Icons.layers),
      ),
    );
  }
}
