import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '.env.dart';
import 'directions_model.dart';

class DirectionRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'destination': '${destination.latitude},${destination.longitude}',
        'origin': '${origin.latitude},${origin.longitude}',
        'mode': 'transit',
        'key': googleAPIKey,
      },
    );
    // log({
    //   'destination': '${destination.latitude},${destination.longitude}',
    //   'origin': '${origin.latitude},${origin.longitude}',
    //   'mode': 'transit',
    //   'key': googleAPIKey,
    // }.toString().replaceAll(', ', '&').replaceAll(': ', '='));
    if (response.statusCode == 200) {
      // print('${response.data}');
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
