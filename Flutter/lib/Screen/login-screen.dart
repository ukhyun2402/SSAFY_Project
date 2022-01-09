import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:main/service/MemberService.dart';
import 'package:main/globals.dart' as g;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var mService = MemberService();
  String email = "";
  String password = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("pref check " + g.prefs!.toString());
    log("pref check " + g.prefs!.getInt('loginIdx').toString());
  }

  @override
  Widget build(BuildContext context) {
    // if (g.loginMember.id != null) {
    //   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    // }
    var login = (email, password) async {
      bool result = await mService.login(email, password);
      if (result) {
        log("Login Screen, Set SharedPreference");
        g.prefs?.setInt('loginIdx', g.loginMember.id!);
        log("Login Screen, pref Value Check, ${g.prefs?.getInt('loginIdx')}");
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    };
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 30),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('asset/images/logo.jpg')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: '이메일을 입력해주세요'),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                    onEditingComplete: () {
                      login(email, password);
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: '비밀번호를 입력해주세요'),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    }),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    log("login button clicked");
                    login(email, password);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  "회원가입",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
