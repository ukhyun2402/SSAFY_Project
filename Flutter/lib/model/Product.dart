import 'dart:convert';

import 'package:main/model/Review.dart';

class Product {
  int? id;
  String? productName;
  int? price;
  String? category;
  String? productImgPath;
  List<dynamic>? reviews;

  Product({
    this.id,
    this.productName,
    this.price,
    this.category,
    this.productImgPath,
    this.reviews,
  });

  @override
  bool operator ==(other) {
    return (other is Product) && other.id == id && other.id == id;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        productName: json['productName'],
        price: json['price'],
        category: json['category'],
        productImgPath: json['productImgPath'],
        reviews: json['reviews']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': productName,
        'password': price,
        'phoneNumber': category,
      };
}
