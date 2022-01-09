import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

class Event {
  final int id;
  final String eventName;
  final String? subTitle;
  final String routePageName;
  final String? imagePath;

  Color random =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  Event(
      {required this.id,
      required this.eventName,
      this.subTitle,
      required this.routePageName,
      this.imagePath});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      eventName: json['email'],
      routePageName: json['route_page_name'],
      subTitle: json['descripbtion'],
      imagePath: json['image_path'],
    );
  }

  static get math => null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventName': eventName,
        'routePageName': routePageName,
        'description': subTitle,
        'imagepath': imagePath,
      };
}
