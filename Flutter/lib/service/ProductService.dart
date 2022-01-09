import 'dart:developer';

import 'package:main/model/Event.dart';
import 'package:main/globals.dart' as g;
import 'package:main/model/Product.dart';

import '../event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  String baseUrl = g.baseURL;

  Future<dynamic> getProducts() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET', Uri.parse('$baseUrl/products'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      return null;
    }
  }

  Future<Product?> getProduct(int id) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET', Uri.parse('$baseUrl/product/$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // log(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      return Product.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      return null;
    }
  }
}
