import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';
import 'package:main/Components/drawer.dart';
import 'package:main/model/Order.dart';
import 'package:main/product-detail.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:main/service/OrderService.dart';
import 'Components/card-with-overflow-image.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'globals.dart' as g;

class UserInfoScreen extends StatefulWidget {
  // const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoScreen>
    with SingleTickerProviderStateMixin {
  TextStyle titleStyle = TextStyle(
    fontFamily: "titan",
    fontSize: 30.0,
    color: Color(0xff1A1A1A),
    fontStyle: FontStyle.italic,
  );

  TextStyle headerStyle = TextStyle(
    fontFamily: "Gowun",
    fontSize: 20.0,
    color: Color(0xff1A1A1A),
    fontWeight: FontWeight.bold,
  );

  Widget _stamp(BuildContext context) {
    return StepProgressIndicator(
      totalSteps: 10,
      currentStep: 4,
      size: 50,
      selectedColor: Color(0xffDBD0C0),
      unselectedColor: Colors.white,
      customStep: (index, color, _) => color == Color(0xffDBD0C0)
          ? Container(
              color: color,
              child: Icon(
                Icons.check,
                color: Colors.brown[250],
              ),
            )
          : Container(
              color: color,
              child: Icon(
                Icons.remove,
              ),
            ),
    );
  }

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _tabBar(BuildContext context) {
    return ColorfulTabBar(
      alignment: TabAxisAlignment.end,
      indicatorHeight: 6,
      labelStyle: headerStyle,
      selectedHeight: 48,
      unselectedHeight: 40,
      tabs: [
        TabItem(
            color: Color.fromARGB(255, 245, 207, 140),
            title: Text(
              '내 정보',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.normal),
            )),
        TabItem(
            color: Color.fromARGB(255, 254, 229, 229),
            title: Text(
              '주문내역',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.normal),
            )),
      ],
      controller: _tabController,
    );
  }

  Widget _myInfo(int index) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '스탬프',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                  child: _stamp(context),
                ),
                Container(
                  margin: EdgeInsets.only(right: 11),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '4/10',
                    style: titleStyle.copyWith(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Point',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                  child: _stamp(context),
                ),
                Container(
                  margin: EdgeInsets.only(right: 11),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '4/10',
                    style: titleStyle.copyWith(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coupon',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Center(child: Text('쿠폰 들어갈 자리')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myOrder(int index) {
    return Container(
      height: 100,
      color: Colors.red,
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: FutureBuilder(
        future: OrderService().getOrders(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            List<Order> orders = (snapshot.data as List<Order>);
            return Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  // log(message)
                  return Text("");
                  // return Text("${orders[index].dateTime}");
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 246, 240),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: -100,
              top: -95,
              child: Container(
                width: 310,
                height: 310,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(214, 232, 195, 163),
                ),
              ),
            ),
            Container(
                // margin: EdgeInsets.only(left: 10),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 70,
                // ),
                Container(
                  margin:
                      EdgeInsets.only(top: 16, bottom: 12, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "마이페이지",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        "탭을 눌러 다른 정보들도 확인할 수 있습니다",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Text(
                      '${g.loginMember.name}님',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(width: 10.0, height: 70.0),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.headline4!,
                      child: AnimatedTextKit(
                        isRepeatingAnimation: true,
                        totalRepeatCount: 10,
                        animatedTexts: [
                          RotateAnimatedText(
                            '안녕하세요',
                          ),
                          RotateAnimatedText('오늘도 좋은 하루 되세요'),
                        ],
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                  ],
                ),
                _tabBar(context),
                Expanded(
                  child: TabBarView(
                      controller: _tabController,
                      children: [_myInfo(0), _myOrder(1)]),
                ),
              ],
            )),
          ],
        ),
      ),
      drawer: CustomDrawer(context),
    );
  }
}

// InkWell(
// onTap: () {
// print('Item 클릭됨');
// Navigator.push(context,
// MaterialPageRoute(builder: (context) => ProductDetial()));
// },
// child: Container(
// // color: Colors.black,
// child: SingleChildScrollView(
// scrollDirection: Axis.horizontal,
// child: Row(
// children: [
// CardWIthOverflowImage(
// coffeeImgPath: 'asset/images/coffee1_2.png',
// ),
// CardWIthOverflowImage(),
// CardWIthOverflowImage(),
// ],
// )),
// ),
// ),