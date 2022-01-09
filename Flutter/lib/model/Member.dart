import 'dart:convert';

class Member {
  int? id;
  final String email;
  final String? password;
  String? name;
  String? phoneNumber;
  int? point;
  int? stamp;
  String? img;

  Member(
      {this.id,
      required this.email,
      this.password,
      this.name,
      this.phoneNumber,
      this.point,
      this.stamp,
      this.img});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        point: json['point'],
        stamp: json['stamp'],
        img: json['img']);
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'name': name
      };
}
