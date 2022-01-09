import 'dart:convert';

import 'package:main/model/Review.dart';

class Order {
  int? id;
  int? memberId;
  String? dateTime;
  List<dynamic>? orderDetails;

  Order({
    this.id,
    this.memberId,
    this.dateTime,
    this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      memberId: json['memberId'],
      dateTime: json['dateTime'],
      orderDetails: json['orderDetails'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'memberId': memberId,
      };
}
