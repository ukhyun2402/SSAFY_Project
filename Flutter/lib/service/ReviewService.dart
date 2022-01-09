import 'dart:developer';

import 'package:main/model/Event.dart';
import 'package:main/globals.dart' as g;
import 'package:main/model/Review.dart';

import '../event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewService {
  String baseUrl = g.baseURL;

  Future<List<dynamic>> getReviews(int productId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET', Uri.parse('$baseUrl/reviews/$productId'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var tmp =
          jsonDecode(await response.stream.bytesToString()) as List<dynamic>;
      tmp.map((e) => Review.fromJson(e));
      return tmp;
    } else {
      return [];
    }
  }
}
