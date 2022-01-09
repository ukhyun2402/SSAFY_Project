import 'dart:convert';
import 'dart:developer';
// import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:main/model/Member.dart';
import '/globals.dart' as g;

class MemberService {
  String baseUrl = g.baseURL;

  Future<bool> login(email, password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$baseUrl/login'));
    var result = false;
    request.body = json.encode({"email": email, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var tmp =
          Member.fromJson(jsonDecode(await response.stream.bytesToString()));
      if (tmp.email == "") return result;
      g.loginMember = tmp;
      result = true;
    } else {
      print("error");
    }
    return result;
  }

  Future<Member> getMember(id) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET', Uri.parse('$baseUrl/member/$id'));
    // var result = false;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return Member.fromJson(jsonDecode(await response.stream.bytesToString()));
    } else {
      print("GetMember Service Error");
    }
    return Member(email: '');
  }

  Future<bool> idCheck(email) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$baseUrl/idCheck'));
    request.body = json.encode({"id": email});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await int.parse(
          jsonDecode(await response.stream.bytesToString()).toString());
      return result == 0;
    } else {
      log("server error");
    }
    return false;
  }

  Future<int?> phoneCheck(phoneNumber) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$baseUrl/phoneCheck'));
    request.body = json.encode({"phone_number": phoneNumber});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await int.parse(
          jsonDecode(await response.stream.bytesToString()).toString());
      return result;
    } else {
      log("server error");
      return null;
    }
  }

  Future<int?> addPoint(phoneNumber, point) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('PUT', Uri.parse('$baseUrl/member/$phoneNumber/$point'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // log(Uri.parse('$baseUrl/member/$phoneNumber/$point').toString());
    if (response.statusCode == 200) {
      return int.parse(
          jsonDecode(await response.stream.bytesToString()).toString());
    } else {
      log("server error");
      return null;
    }
  }

  Future<bool> signUp(Member member) async {
    // log(member.toJson().toString());
    var json = jsonEncode(member.toJson());
    // log(json);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$baseUrl/signUp'));
    request.body = jsonEncode(member.toJson());
    // log(json.encode({member.toJson()}));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = int.parse(
          jsonDecode(await response.stream.bytesToString()).toString());

      member.id = result;
      g.loginMember = member;
      log("LoginedMember PhoneNumber: " + member.phoneNumber.toString());
      g.prefs?.setInt('loginIdx', result);
      return result > 0;
    } else {
      log("server error");
    }
    return false;
  }
}

class Int {}
