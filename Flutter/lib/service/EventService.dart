import 'dart:developer';

import 'package:main/model/Event.dart';
import 'package:main/globals.dart' as g;

import '../event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventService {
  String baseUrl = g.baseURL;

  Future<dynamic> eventList() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET', Uri.parse('$baseUrl/events'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      return [];
    }
  }
}
