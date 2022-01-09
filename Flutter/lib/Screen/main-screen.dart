import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:main/Components/card-with-overflow-image-new.dart';
import 'package:main/Components/shop-info.dart';
import 'package:main/globals.dart' as g;

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:main/Components/slide-card.dart';
import 'package:main/model/Event.dart';
import 'package:main/service/EventService.dart';
import 'package:main/service/MemberService.dart';
import 'package:main/service/ProductService.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'package:main/Components/button-simple.dart';
import 'package:main/Components/card-with-diagonal.dart';
import 'package:main/Components/card-with-overflow-image.dart';
import 'package:main/Components/clip-path.dart';
import 'package:main/Components/custom-scaffold.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var eventService = EventService();
  var productService = ProductService();

  @override
  void initState() {
    super.initState();
    // log("SharedPreference" + g.prefs!.getInt("loginIdx").toString());
    // log("Global Variable" + g.loginMember.name.toString());
    if (g.loginMember.name == null || g.loginMember.phoneNumber == null) {
      log("MainScreen, 글로벌 멤버 변수에 값 저장 안되어있음");
      setState(() {
        MemberService().getMember(g.prefs?.getInt('loginIdx')).then((value) {
          g.loginMember = value;
        });
      });
    }
  }

  int _eventCardIndex = 0;
  @override
  Widget build(BuildContext context) {
    // log(g.loginMember.toJson().toString());
    return CustomScaffold(
        body: SafeArea(
      child: Stack(children: [
        // 웨이브 배경
        Transform.rotate(
          angle: 180 * math.pi / 180,
          child: Container(
            child: WaveWidget(
              // backgroundColor: Colors.black,
              config: CustomConfig(
                gradients: [
                  [
                    Color.fromARGB(182, 230, 219, 208),
                    Color.fromARGB(255, 227, 224, 218)
                  ],
                  [
                    Color.fromARGB(255, 222, 220, 211),
                    Color.fromARGB(189, 234, 230, 209)
                  ],
                  [
                    Color.fromARGB(255, 194, 189, 178),
                    Color.fromARGB(184, 227, 227, 213)
                  ],
                  [
                    Color(0xFFF2EDE1),
                    Color.fromARGB(235, 255, 253, 248),
                  ],
                ],
                durations: [19000, 22000, 15000, 17000],
                heightPercentages: [0.01, 0.06, 0.11, 0.08],
                gradientBegin: Alignment.topRight,
                gradientEnd: Alignment.bottomLeft,
              ),
              size: Size(
                double.infinity,
                double.infinity,
              ),
            ),
          ),
        ),
        Positioned(
          left: -150,
          top: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
                color: Color.fromARGB(95, 130, 111, 13),
                shape: BoxShape.circle),
          ),
        ),
        // Positioned(
        //   left: 90,
        //   top: 120,
        //   child: Container(
        //     width: 250,
        //     height: 250,
        //     decoration: BoxDecoration(
        //         color: Color.fromARGB(255, 255, 249, 219),
        //         shape: BoxShape.circle),
        //   ),
        // ),
        Positioned(
          right: -50,
          top: -50,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
                color: Color.fromARGB(88, 156, 148, 108),
                shape: BoxShape.circle),
          ),
        ),
        Container(
          // color: Color.fromARGB(255, 248, 247, 242),
          child: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.fromLTRB(16, 35, 16, 20),
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "${g.loginMember.name}님,",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(wordSpacing: 0.5)
                                  .copyWith(),
                              children: [
                            TextSpan(
                              text: " 돌멩이 카페에 오신것을 환영합니다",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(wordSpacing: 0.5),
                            ),
                          ])),
                      Text(
                        "돌멩이 카페에서 여유를 즐기세요",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 10),
                width: double.infinity,
                child: Column(children: [
                  FutureBuilder(
                      future: _fetchEventList(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none &&
                                snapshot.hasData == false ||
                            snapshot.data == null) {
                          // print('project snapshot data is: ${snapshot.data}');
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return CarouselSlider(
                            items:
                                (snapshot.data as List<dynamic>).map((event) {
                              return Builder(builder: (BuildContext context) {
                                // log(event.toString());
                                // log(_eventCardIndex.toString());
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        event['routePageName'].toString());
                                  },
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                          color: Color.fromARGB(
                                              255, 216, 249, 244),
                                          child: SlideCard(
                                            title:
                                                event['eventName'].toString(),
                                            subTitle: event['routePageName']
                                                .toString(),
                                            imagePath:
                                                event['imagePath'].toString(),
                                          ))),
                                );
                              });
                            }).toList(),
                            options: CarouselOptions(
                                initialPage: 0,
                                viewportFraction: 0.9,
                                // autoPlay: true,
                                aspectRatio: 2 / 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _eventCardIndex = index;
                                  });
                                }),
                          );
                        }
                      }),
                ]),
              ),
              Container(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(wordSpacing: 0.5)
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                              children: [
                            TextSpan(
                              text: "이런 메뉴는 어떠세요?",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(wordSpacing: 0.5),
                            ),
                          ])),
                    ]),
              ),
              Container(
                // color: Colors.black,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _fetchProducts(),
                      builder: (context, snapshop) {
                        // log((snapshop.data as List<dynamic>)[0].toString());
                        if (snapshop.hasData == false) {
                          return CircularProgressIndicator();
                        } else {
                          var products = (snapshop.data as List<dynamic>);
                          return Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: products
                                      .map((product) =>
                                          CardWIthOverflowImageNew(
                                            customWidth: 170,
                                            coffeeImgPath:
                                                product['productImgPath'],
                                            itemName: product['productName'],
                                            subTitle:
                                                product['price'].toString() +
                                                    "원",
                                            onTabMethod: () {
                                              Navigator.pushNamed(
                                                  context, '/order',
                                                  arguments: product['id']);
                                            },
                                          ))
                                      .toList()),
                            ),
                          );
                        }
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "저희는 이런 카페에요!",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ButtonSimple(
                                    text: "카페 정보",
                                    icon: Icons.store,
                                    onTab: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                                title: "돌멩이 카페",
                                                descriptions:
                                                    "\n\n\n\n돌멩이 카페를 찾아주셔서 감사합니다\n\n영업시간\n\n 평일 09:00 - 25:00\n 주말 10:00 - 26:00\n\n전화 문의: 안받음\n\n\n\n주소: 대구광역시 수성구 수성못 근처",
                                                text: "",
                                                img: Image.asset(
                                                    'asset/images/logo.jpg'));
                                          });
                                    },
                                  ),
                                  ButtonSimple(
                                    text: "카페 위치",
                                    icon: Icons.location_on,
                                    onTab: () {
                                      Navigator.pushNamed(context, '/map');
                                    },
                                  ),
                                  // ButtonSimple(
                                  //   text: "회원 혜택",
                                  //   icon: Icons.wallet_membership,
                                  // ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "혹시 이걸 찾으시나요?",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  CardWithDiagonal(
                                    category: '포인트\n선물하기',
                                    route: '/giftcard',
                                  )
                                ],
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              )
            ]),
          )),
        ),
      ]),
    ));
  }

  Future _fetchEventList() async {
    return await eventService.eventList();
  }

  Future _fetchProducts() async {
    return await productService.getProducts();
  }
}
