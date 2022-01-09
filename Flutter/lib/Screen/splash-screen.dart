import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:main/Screen/login-screen.dart';
import 'package:main/Screen/main-screen.dart';
import 'package:main/service/MemberService.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:main/globals.dart' as g;

// void main(List<String> args) {
//   runApp(MaterialApp(
//     home: Scaffold(
//       body: Splash(),
//     ),
//   ));
// }

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
//   _loadMemberData(int? idx) async {
//     await MemberService().getMember(idx).then((value) => g.loginMember = value);
//   }

  @override
  void initState() {
    g.setSharedPreferences();
    Timer(Duration(milliseconds: 2500), () {
      if (g.prefs?.getInt('loginIdx') == null) {
        log("Splash Screen pref not found");
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        log("Splash Screen pref found");
        // _loadMemberData(g.prefs?.getInt('loginIdx'));
        MemberService().getMember(g.prefs?.getInt('loginIdx')).then((value) {
          g.loginMember = value;
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        });
      }
      // MemberService().getMember(g.prefs?.getInt('loginIdx')).then((value) {
      //   if (value != null) {
      //     log("value check" + value.email.toString());
      //     log("pref check " + g.prefs!.toString());
      //     g.loginMember = value;
      // }
    });
    // Navigator.of(context)
    //     .push(PageRouteBuilder(pageBuilder: (context, animation, secodary) {
    //   // if (g.prefs?.getInt('loginIdx')) {
    //   MemberService().getMember(g.prefs?.getInt('loginIdx')).then((value) {
    //     if (value != null) {
    //       g.loginMember = value;
    //       Navigator.pushNamedAndRemoveUntil(
    //           context, '/', (route) => false);
    //     }
    //   });
    //   // }
    //   return (g.prefs?.getInt('loginIdx') != null)
    //       ? LoginScreen()
    //       : MainScreen();
    // }, transitionsBuilder: (context, animation, secondary, child) {
    //   var begin = Offset(0.0, 5.0);
    //   var end = Offset.zero;
    //   var curve = Curves.ease;

    //   var tween =
    //       Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    //   return SlideTransition(
    //     // opacity: CurvedAnimation(),

    //     position: animation.drive(tween),
    //     child: child,
    //   );
    // }));
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(Duration(seconds: 2), (timer) {
    //   Navigator.pushNamed(context, '/login');
    //   // debugPrint(timer.tick.toString());
    //   if (timer.tick > 2) {
    //     timer.cancel();
    //   }
    // });
    // var index = 0;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'asset/images/logo.jpg',
                        scale: 5,
                      ),
                      Container(
                        // width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 12,
                                color: Color.fromARGB(255, 186, 186, 186)),
                            shape: BoxShape.circle),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "돌멩이 카페에 찾아주셔서\n감사합니다.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
