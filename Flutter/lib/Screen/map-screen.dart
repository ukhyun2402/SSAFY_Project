import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:main/util/directions_model.dart';
import 'package:main/util/directions_repository.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late BitmapDescriptor cafeMarker;
  Marker? _origin = null;
  Marker? _destination = null;
  Directions? _info = null;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(35.86414166439446, 128.59970547258854),
    zoom: 12.5,
  );

  late GoogleMapController _googleController;

  @override
  void dispose() {
    _googleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getMyLocation()
        .then((value) => _addMarker(LatLng(value.latitude, value.longitude)));
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(0.5, 0.5)),
            'asset/images/marker-tiny.png')
        .then((value) {
      cafeMarker = value;
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('돌멩이'),
          infoWindow: const InfoWindow(title: '돌멩이 카페'),
          draggable: true,
          icon: cafeMarker,
          position: LatLng(35.83025863365309, 128.62278923392296),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Google Map"),
        actions: [
          // TextButton(
          //   onPressed: () => _googleController.animateCamera(
          //     CameraUpdate.newCameraPosition(CameraPosition(
          //       target: _origin!.position,
          //       zoom: 14.5,
          //       tilt: 50.0,
          //     )),
          //   ),
          //   style: TextButton.styleFrom(
          //     primary: Colors.white,
          //     textStyle: const TextStyle(fontWeight: FontWeight.w600),
          //   ),
          //   child: const Text('출발지'),
          // ),
          // if (_destination != null)
          //   TextButton(
          //     onPressed: () => _googleController.animateCamera(
          //       CameraUpdate.newCameraPosition(
          //         CameraPosition(
          //           target: _destination!.position,
          //           zoom: 17.5,
          //           tilt: 50.0,
          //         ),
          //       ),
          //     ),
          //     style: TextButton.styleFrom(
          //       primary: Colors.white,
          //       textStyle: const TextStyle(fontWeight: FontWeight.w600),
          //     ),
          //     child: const Text('카페'),
          //   ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _googleController = controller,
              markers: {
                if (_origin != null) _origin!,
                if (_destination != null) _destination!,
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Color.fromARGB(255, 66, 162, 252),
                    width: 5,
                    points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
              onTap: _addMarker,
            ),
            if (_info != null)
              Positioned(
                  top: 20.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 91, 91, 91),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          )
                        ]),
                    child: Text(
                      '${_info!.totalDistance}, ${_info!.totalDuration}',
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      //   onPressed: () => _googleController.animateCamera(

      //     _info != null
      //         ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
      //         : CameraUpdate.newCameraPosition(_initialCameraPosition),
      //   ),
      //   child: const Icon(Icons.center_focus_strong),
      // ),
    );
  }

  void _addMarker(LatLng pos) async {
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: pos,
      );
      // print('출발지 => ${_origin!.position}');

      //Reset info
      _info = null;
    });

    final directions = await DirectionRepository().getDirections(
        origin: _origin!.position, destination: _destination!.position);
    setState(() => _info = directions!);
  }
}

Future<Position> getMyLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
