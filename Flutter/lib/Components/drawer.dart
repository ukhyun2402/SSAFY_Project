import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:main/globals.dart' as g;
import 'package:main/model/Member.dart';

Widget CustomDrawer(BuildContext context) {
  TextStyle drawerheaderStyle = TextStyle(
    fontFamily: "titan",
    fontSize: 15.0,
    color: Color(0xff1A1A1A),
  );

  TextStyle drawerlistStyle = TextStyle(
    fontSize: 20.0,
    color: Color(0xff1A1A1A),
  );

  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 237, 233, 229),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "돌멩이 카페",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      g.loginMember = Member(email: '');
                      g.prefs?.remove('loginIdx');
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(7, 2, 5, 2),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 93, 93, 93),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            "로그아웃",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.white),
                          ),
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                decoration: BoxDecoration(
                  // color: Colors.red,
                  border: Border(
                    left: BorderSide(
                        width: 3, color: Color.fromARGB(255, 179, 128, 100)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 72, 64, 57),
                              shape: BoxShape.circle),
                          width: 50,
                          height: 50,
                          child: Center(
                            child: CircleAvatar(
                                backgroundImage: (g.loginMember.img != null)
                                    ? Image.network(g.baseURL_image +
                                            g.loginMember.img!)
                                        .image
                                    : null),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${g.loginMember.name}",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            "${g.loginMember.email}",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            "${g.loginMember.phoneNumber}",
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "현재 보유 포인트",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            "${g.loginMember.point}점",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        DrawerItem(context, "회원정보", "나의 정보를 볼 수 있습니다", () {
          Navigator.pushNamed(context, '/mypage');
        }),
        DrawerItem(context, "주문", "돌멩이 카페의 커피를 맛볼 수 있습니다.", () {
          Navigator.pushNamed(context, '/order');
        }),
      ],
    ),
    // child: Container(
    //   color: Color.fromARGB(255, 237, 233, 229),
    //   child: Column(
    //     children: [
    //       UserAccountsDrawerHeader(
    //         currentAccountPicture: Container(
    //           width: double.infinity,
    //           color: Colors.red,
    //         ),
    //         // CircleAvatar(
    //         //   backgroundImage:
    //         //       Image.network(g.baseURL_image + g.loginMember.img!).image,
    //         //   backgroundColor: Colors.white,
    //         // ),
    //         accountName: Text(
    //           '${g.loginMember.name}',
    //           style: Theme.of(context).textTheme.headline3,
    //         ),
    //         accountEmail: Text(
    //           '${g.loginMember.email}',
    //           style: Theme.of(context).textTheme.headline3,
    //         ),
    //         // 화살표 없앰
    //         onDetailsPressed: null,
    //         decoration: BoxDecoration(
    //             color: Color(0xffDBD0C0),
    //             borderRadius: BorderRadius.only(
    //                 bottomLeft: Radius.circular(40.0),
    //                 bottomRight: Radius.circular(40.0))),
    //       ),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       Stack(children: [
    //         Column(
    //           children: [
    //             Container(
    //               margin: EdgeInsets.all(10),
    //               padding: EdgeInsets.all(10),
    //               alignment: Alignment.center,
    //               height: 10,
    //               decoration: BoxDecoration(
    //                   color: Color(0xffF7F2ED),
    //                   borderRadius: BorderRadius.all(Radius.circular(30.0))),
    //             ),
    //             Container(
    //               margin: EdgeInsets.all(10),
    //               padding: EdgeInsets.all(10),
    //               alignment: Alignment.center,
    //               height: 100,
    //               decoration: BoxDecoration(
    //                   color: Color(0xffDBD0C0),
    //                   borderRadius: BorderRadius.all(Radius.circular(30.0))),
    //               child: Text(
    //                 "주문내역",
    //                 style: drawerheaderStyle,
    //               ),
    //             ),
    //           ],
    //         ),
    //         Row(
    //           children: [
    //             SizedBox(
    //               width: 190,
    //             ),
    //             Image.asset(
    //               'assets/berry.png',
    //               height: 150,
    //             )
    //           ],
    //         )
    //       ]),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       InkWell(
    //         onTap: () {
    //           print('UserInfo 클릭됨');
    //           if (ModalRoute.of(context)!.settings.name.toString() !=
    //               '/mypage') {
    //             // Drawer 접기
    //             Navigator.of(context).pop();
    //             Navigator.pushNamed(context, '/mypage');
    //           }
    //           // Navigator.push(
    //           //   context,
    //           //   MaterialPageRoute(builder: (context) => UserInfoScreen()),
    //           // );
    //         },
    //         child: Container(
    //           margin: EdgeInsets.all(10),
    //           padding: EdgeInsets.all(10),
    //           alignment: Alignment.center,
    //           height: 100,
    //           decoration: BoxDecoration(
    //               color: Color(0xffDBD0C0),
    //               borderRadius: BorderRadius.all(Radius.circular(30.0))),
    //           child: Text(
    //             "회원정보",
    //             style: drawerheaderStyle,
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       Container(
    //         margin: EdgeInsets.all(10),
    //         padding: EdgeInsets.all(10),
    //         alignment: Alignment.center,
    //         height: 100,
    //         decoration: BoxDecoration(
    //             color: Color(0xffDBD0C0),
    //             borderRadius: BorderRadius.all(Radius.circular(30.0))),
    //         child: Text(
    //           "주문내역",
    //           style: drawerheaderStyle,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
  );
}

Widget DrawerItem(
    BuildContext context, String title, String subTitle, VoidCallback? onTab) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
      onTab!();
    },
    child: Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyText2!,
          ),
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.centerRight,
              colors: [
            Color.fromARGB(255, 232, 229, 226),
            Color.fromARGB(255, 232, 229, 226),
            Color.fromARGB(255, 152, 152, 152),
          ])),
    ),
  );
}
