import 'package:flutter/material.dart';
import 'package:main/Screen/busket-screen.dart';
import 'package:main/Screen/login-screen.dart';
import 'package:main/Screen/map-screen.dart';
import 'package:main/Screen/order-detail-screen.dart';
import 'package:main/Screen/giftcard-screen.dart';
import 'package:main/Screen/category-screen.dart';
import 'package:main/Screen/main-screen.dart';
import 'package:main/Screen/splash-screen.dart';
import 'package:main/event.dart';
import 'package:main/service/EventService.dart';
import 'package:main/test/coin-avatar.dart';
import 'package:main/theme/CustomeTheme.dart';
import 'package:main/userinfo-screen.dart';

import 'Screen/order-screen.dart';
import 'Screen/ordered-list-screen.dart';

import 'Screen/signup-screen.dart';
import 'globals.dart' as global;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (context) => MainScreen(),
        '/category': (context) => CategoryScreen(),
        '/giftcard': (context) => GiftCard(),
        '/ordered-list': (context) => OrderedListScreen(),
        '/order-detail': (context) => OrderDetailScreen(),
        '/order': (context) => OrderScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/splash': (context) => Splash(),
        '/bucket': (context) => BusketScreen(),
        '/rouletts': (context) => RoulettEvent(),
        '/mypage': (context) => UserInfoScreen(),
        '/map': (context) => MapScreen(),
      },
      initialRoute: '/splash',
      theme: ThemeData(
          primarySwatch: Palette.kToDark,
          primaryColor: Color(0xFF2C282F),
          textTheme: const TextTheme(
            headline5: TextStyle(
              fontSize: 13,
              // fontWeight: FontWeight.bold,
              fontFamily: 'gowun',
            ),
            headline1: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'gowun',
            ),
            headline2: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'gowun',
            ),
            headline3: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'gowun',
            ),
            headline4: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'gowun',
            ),
            bodyText1: TextStyle(
              fontSize: 12,
              fontFamily: 'gowun',
            ),
            bodyText2: TextStyle(
              fontSize: 10,
              fontFamily: 'gowun',
            ),
          )),
      // home: GiftCard(),
      // home: CoinAvatar(
      //   image: "https://ssl.pstatic.net/static/common/footer/ci_naver.png",
      // ),
    );
  }
}
