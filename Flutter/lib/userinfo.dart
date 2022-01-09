import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:main/product-detail.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Components/card-with-overflow-image.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class UserInfo extends StatefulWidget {
  // const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  TextStyle titleStyle = TextStyle(
    fontFamily: "titan",
    fontSize: 30.0,
    color: Color(0xff1A1A1A),
    fontStyle: FontStyle.italic,
  );

  TextStyle drawerheaderStyle = TextStyle(
    fontFamily: "titan",
    fontSize: 15.0,
    color: Color(0xff1A1A1A),
  );

  TextStyle drawerlistStyle = TextStyle(
    fontSize: 20.0,
    color: Color(0xff1A1A1A),
  );

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xffF7F2ED),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/avatar.png'),
                backgroundColor: Colors.white,
              ),
              accountName: Text(
                'Name',
                style: drawerheaderStyle,
              ),
              accountEmail: Text(
                'test@email.com',
                style: drawerheaderStyle,
              ),
              onDetailsPressed: () {
                print('헤더 클릭됨');
              },
              decoration: BoxDecoration(
                  color: Color(0xffDBD0C0),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            SizedBox(
              height: 20,
            ),
            Stack(children: [
              Column(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Color(0xffF7F2ED),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Color(0xffDBD0C0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        child: Text(
                          "주문내역",
                          style: drawerheaderStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 190,
                  ),
                  Image.asset(
                    'assets/berry.png',
                    height: 150,
                  )
                ],
              )
            ]),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                print('UserInfo 클릭됨');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserInfo()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                    color: Color(0xffDBD0C0),
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Text(
                  "회원정보",
                  style: drawerheaderStyle,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 100,
              decoration: BoxDecoration(
                  color: Color(0xffDBD0C0),
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: Text(
                "주문내역",
                style: drawerheaderStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stamp(BuildContext context) {
    return StepProgressIndicator(
      totalSteps: 10,
      currentStep: 4,
      size: 50,
      selectedColor: Color(0xffDBD0C0),
      unselectedColor: Colors.white,
      // customStep: (index, color, _) => color == Color(0xff1A1A1A)
      customStep: (index, color, _) => (index < 4)
          ? Container(
              color: color,
              child: Icon(
                Icons.check,
                color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EDE1),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 70,
          ),
          Text(
            " User Info",
            style: titleStyle,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 20.0, height: 100.0),
              Text(
                '안녕하세요,',
                style: titleStyle.copyWith(fontSize: 20.0),
              ),
              SizedBox(width: 20.0, height: 100.0),
              DefaultTextStyle(
                style: titleStyle.copyWith(fontSize: 20.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText('test님'),
                    RotateAnimatedText('오늘도 좋은 일들만 가득하세요'),
                  ],
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              print('Item 클릭됨');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductDetial()));
            },
            child: Container(
              // color: Colors.black,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CardWIthOverflowImage(
                        coffeeImgPath: 'asset/images/coffee1_2.png',
                      ),
                      CardWIthOverflowImage(),
                      CardWIthOverflowImage(),
                    ],
                  )),
            ),
          ),
          Text(
            'Stamp',
            style: titleStyle.copyWith(fontSize: 20.0),
          ),
          Container(
              child: _stamp(context)),
        ],
      )),
      drawer: _drawer(context),
    );
  }
}
