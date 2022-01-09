import 'dart:developer';
import 'dart:ui';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:main/Components/drawer.dart';
import 'package:main/model/Member.dart';
import 'package:main/service/MemberService.dart';
import 'package:main/userinfo.dart';
import 'package:main/util/CheckValidate.dart';
import 'package:main/globals.dart' as g;

class GiftCard extends StatefulWidget {
  @override
  _GiftCardState createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  var bottomDrawerIsVisible = false;
  bool isVisible = false;
  String errorMsg = "자신에게는 선물을 보낼 수 없습니다.";
  bool error = false;
  int selectedCardIndex = 0;

  TextStyle titleStyle = TextStyle(
    fontFamily: "titan",
    fontSize: 30.0,
    color: Color(0xff1A1A1A),
    fontStyle: FontStyle.italic,
  );

  // TextStyle drawerheaderStyle = TextStyle(
  //   fontFamily: "titan",
  //   fontSize: 15.0,
  //   color: Color(0xff1A1A1A),
  // );

  // TextStyle drawerlistStyle = TextStyle(
  //   fontSize: 20.0,
  //   color: Color(0xff1A1A1A),
  // );

  BottomDrawerController _controller = BottomDrawerController();

  late List<dynamic> cardList;

  final _phonelKey = GlobalKey<FormFieldState>();
  FocusNode phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    cardList = [
      {"image": "assets/giftcard0.png", "price": "5000"},
      {"image": "assets/giftcard1.png", "price": "10000"},
      {"image": "assets/giftcard2.png", "price": "15000"},
      {"image": "assets/giftcard3.png", "price": "20000"},
      {"image": "assets/giftcard4.png", "price": "30000"},
      {"image": "assets/giftcard5.png", "price": "50000"},
    ];
  }

  Widget _buildCardView() {
    return Container(
        child: CarouselSlider.builder(
      itemCount: cardList.length,
      itemBuilder: (context, index, realIdx) {
        return Container(
          // width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              // color: Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.all(Radius.circular(13))),

          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 12,
                      offset: Offset(6, 8),
                    )
                  ]),
              child: Image.asset(
                cardList[index]['image'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        onPageChanged: (value, reason) {
          setState(() {
            selectedCardIndex = value;
          });
        },
        viewportFraction: 0.92,
        autoPlay: false,
        aspectRatio: 16 / 11,
        enlargeCenterPage: true,
      ),
    ));
  }

  Widget _buildBottomDrawer(BuildContext context) {
    return BottomDrawer(
      header: _buildBottomDrawerHead(context),
      body: _buildBottomDrawerBody(context),
      headerHeight: 0.0,
      drawerHeight: 500.0,
      color: Color(0xffffffff),
      controller: _controller,
      callback: (value) {
        bottomDrawerIsVisible = value;
      },
    );
  }

  double _headerHeight = 60.0;
  double _bodyHeight = 500.0;

  // Widget _drawer(BuildContext context) {
  //   return Drawer(
  //     child: Container(
  //       color: Color(0xffF7F2ED),
  //       child: Column(
  //         children: [
  //           UserAccountsDrawerHeader(
  //             currentAccountPicture: CircleAvatar(
  //               backgroundImage: AssetImage('assets/avatar.png'),
  //               backgroundColor: Colors.white,
  //             ),
  //             accountName: Text(
  //               'Name',
  //               style: drawerheaderStyle,
  //             ),
  //             accountEmail: Text(
  //               'test@email.com',
  //               style: drawerheaderStyle,
  //             ),
  //             onDetailsPressed: () {
  //               print('헤더 클릭됨');
  //             },
  //             decoration: BoxDecoration(
  //                 color: Color(0xffDBD0C0),
  //                 borderRadius: BorderRadius.only(
  //                     bottomLeft: Radius.circular(40.0),
  //                     bottomRight: Radius.circular(40.0))),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Stack(children: [
  //             Column(
  //               children: [
  //                 Column(
  //                   children: [
  //                     Container(
  //                       margin: EdgeInsets.all(10),
  //                       padding: EdgeInsets.all(10),
  //                       alignment: Alignment.center,
  //                       height: 10,
  //                       decoration: BoxDecoration(
  //                           color: Color(0xffF7F2ED),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(30.0))),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.all(10),
  //                       padding: EdgeInsets.all(10),
  //                       alignment: Alignment.center,
  //                       height: 100,
  //                       decoration: BoxDecoration(
  //                           color: Color(0xffDBD0C0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(30.0))),
  //                       child: Text(
  //                         "주문내역",
  //                         style: drawerheaderStyle,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 SizedBox(
  //                   width: 190,
  //                 ),
  //                 Image.asset(
  //                   'assets/berry.png',
  //                   height: 150,
  //                 )
  //               ],
  //             )
  //           ]),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           InkWell(
  //             onTap: () {
  //               print('UserInfo 클릭됨');
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => UserInfo()),
  //               );
  //             },
  //             child: Container(
  //               margin: EdgeInsets.all(10),
  //               padding: EdgeInsets.all(10),
  //               alignment: Alignment.center,
  //               height: 100,
  //               decoration: BoxDecoration(
  //                   color: Color(0xffDBD0C0),
  //                   borderRadius: BorderRadius.all(Radius.circular(30.0))),
  //               child: Text(
  //                 "회원정보",
  //                 style: drawerheaderStyle,
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Container(
  //             margin: EdgeInsets.all(10),
  //             padding: EdgeInsets.all(10),
  //             alignment: Alignment.center,
  //             height: 100,
  //             decoration: BoxDecoration(
  //                 color: Color(0xffDBD0C0),
  //                 borderRadius: BorderRadius.all(Radius.circular(30.0))),
  //             child: Text(
  //               "주문내역",
  //               style: drawerheaderStyle,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBottomDrawerHead(BuildContext context) {
    return Container(
      height: 100,
      // width: double.infinity,
      // color: Colors.red,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child: Text(
          "기프트 카드 전달을 위해\n핸드폰 번호를 입력해주세요!",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _bodyHeight,
      child: SingleChildScrollView(
        child: Column(children: [_showPhoneInput()]),
      ),
    );
  }

  Widget _showPhoneInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Stack(alignment: Alignment.centerRight, children: [
                  TextFormField(
                    key: _phonelKey,
                    focusNode: phoneFocus,
                    keyboardType: TextInputType.text,
                    // obscureText: true,
                    onChanged: (value) {
                      _phonelKey.currentState?.validate();
                      if (!_phonelKey.currentState!.hasError) {
                        MemberService().phoneCheck(value).then((response) {
                          // log(value.toString());
                          setState(() {
                            if (g.loginMember.phoneNumber == value) {
                              errorMsg = "자신에게는 보낼 수 없습니다.";
                              error = true;
                              isVisible = true;
                              // log("HELL");
                            } else if (response == 0) {
                              isVisible = true;
                              errorMsg = "없는 핸드폰 번호입니다";
                              error = true;
                            } else {
                              isVisible = false;
                              error = false;
                            }
                          });
                        });
                      }
                    },
                    decoration: _textFormDecoration('핸드폰번호', '핸드폰번호를 입력해주세요'),
                    validator: (value) =>
                        CheckValidate().validatePhone(phoneFocus, value!),
                  ),
                  Visibility(
                    child: Container(
                      child: Text(
                        "$errorMsg",
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.normal, color: Colors.red),
                      ),
                    ),
                    visible: isVisible,
                  )
                ])),
          ],
        ));
  }

  InputDecoration _textFormDecoration(hintText, helperText) {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      hintText: hintText,
      helperText: helperText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EDE1),
      body: WillPopScope(
        onWillPop: () {
          // 뒤로가기 버튼 눌렀을때 드로워 닫히는 코드
          if (bottomDrawerIsVisible) {
            _controller.close();
            bottomDrawerIsVisible = false;
            return Future(() => false);
          } else {
            return Future(() => true);
          }
        },
        child: Stack(children: [
          Positioned(
            left: -150,
            top: -130,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                  color: Color.fromARGB(95, 178, 249, 134),
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: -90,
            bottom: -70,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                  color: Color.fromARGB(95, 129, 249, 217),
                  shape: BoxShape.circle),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    "기프트 카드로 마음을 전달하세요",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    "회원의 핸드폰번호를 입력하면\n해당 회원에게 포인트가 충전됩니다.",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: _buildCardView()),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomDrawer(context),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    elevation: 5,
                    primary: Color.fromARGB(255, 141, 160, 149),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    )),
                onPressed: () {
                  // log("선물하기 버튼 클릭");
                  if (bottomDrawerIsVisible) {
                    if (error || _phonelKey.currentState!.hasError) {
                      g.toast("핸드폰 번호에 오류가 있습니다");
                    } else {
                      MemberService()
                          .addPoint(_phonelKey.currentState?.value,
                              cardList[selectedCardIndex]['price'])
                          .then((value) {
                        if (value! > 0) {
                          g.toast("선물 전달을 완료했습니다");
                        } else {
                          g.toast("선물 전달을 실패했습니다...");
                        }
                        bottomDrawerIsVisible = false;
                      }).onError((error, stackTrace) {
                        g.toast("서버에 에러가 발생했습니다.");
                        // log("에러가 발생했습니다.");
                      });
                      _controller.close();
                    }
                  } else {
                    _controller.open();
                    bottomDrawerIsVisible = true;
                  }
                },
                child: Text("선물하기",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white,
                        ))),
          ],
        ),
      ),
      drawer: CustomDrawer(context),
    );
  }
}
