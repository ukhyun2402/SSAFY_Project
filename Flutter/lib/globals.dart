library globals;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:main/model/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/Member.dart';

Map<Product, int> shoppingCart = {};
Member loginMember = Member(email: '');

var baseURL = "http://192.168.35.139:10001/api";
var baseURL_image = "http://192.168.35.139:10001/images";

var toast = (msg) => Fluttertoast.showToast(
    msg: "$msg",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    fontSize: 16.0);

void addShoppingCart(Product product, int count) {
  if (!shoppingCart.entries.any((element) => element.key.id == product.id)) {
    log("장바구니에 없음");
    shoppingCart.addAll({product: count});
  } else {
    log("장바구니에 있음");
    shoppingCart.keys.where((element) => product == element).forEach((element) {
      shoppingCart.update(element, (value) => value + count);
    });
  }
}

void removeItemFromShoppingCart(Product product) {
  if (shoppingCart.entries.any((element) => element.key.id == product.id)) {
    shoppingCart.removeWhere((key, value) => product.id == key.id);
  }
}

SharedPreferences? prefs = null;

setSharedPreferences() async {
  prefs = await SharedPreferences.getInstance();
}
