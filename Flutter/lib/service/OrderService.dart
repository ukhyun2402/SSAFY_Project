import 'dart:developer';

import 'package:main/model/Event.dart';
import 'package:main/globals.dart' as g;
import 'package:main/model/Order.dart';
import 'package:main/model/Product.dart';

import '../event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderService {
  String baseUrl = g.baseURL;

  Future<bool> postOrder(int memberId, Map<Product, int> orderList) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$baseUrl/order'));
    var orderListJson = [];

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    orderList.forEach((key, value) {
      orderListJson.add({"productId": key.id, "quantity": value});
    });
    request.body = json.encode({
      "memberId": memberId,
      "dateTime": date.toLocal().toString(),
      "orderDetails": orderListJson
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // log(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getOrders() async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('$baseUrl/orders/${g.loginMember.id}'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    // log(response.statusCode.toString());
    if (response.statusCode == 200) {
      // log(response.toString());
      return (await response.stream.bytesToString().then((value) =>
              (jsonDecode(value) as List).map((e) => Order.fromJson(e))))
          .toList();
    } else {
      return [];
    }
  }
}
