import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:main/globals.dart' as g;
import 'package:main/model/Product.dart';
import 'package:main/service/OrderService.dart';

class BusketScreen extends StatefulWidget {
  BusketScreen({Key? key}) : super(key: key);

  @override
  _BusketScreenState createState() => _BusketScreenState();
}

class _BusketScreenState extends State<BusketScreen> {
  Map<Product, int> bucketList = g.shoppingCart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: FloatingActionButton(
              onPressed: () {
                // Navigator.restorablePushNamedAndRemoveUntil(
                //     context, '/order', ModalRoute.withName('/bucket'));
                Navigator.pushReplacementNamed(context, '/order');
              },
              child: Icon(Icons.coffee),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            height: 20,
            child: Text("💁‍♀️주문페이지 "),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF2EDE1),
      body: SafeArea(
        child: Stack(
          children: [
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
            Positioned(
              left: 160,
              top: 60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    color: Color.fromARGB(88, 156, 148, 108),
                    shape: BoxShape.circle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "현재 장바구니에는\n아래의 커피들이\n볶아지고 있습니다",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Expanded(
                      child: (bucketList.length != 0)
                          ? ListView.builder(
                              itemCount: bucketList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Dismissible(
                                  key: Key(bucketList.entries
                                      .elementAt(index)
                                      .key
                                      .id
                                      .toString()),
                                  direction: DismissDirection.startToEnd,
                                  child: ListTile(
                                    title: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(5, 5),
                                                color: Color.fromARGB(
                                                    255, 70, 64, 16))
                                          ],
                                          color:
                                              Color.fromARGB(255, 152, 112, 32),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${bucketList.entries.elementAt(index).key.productName!}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  // TextSpan(
                                                  //   text:
                                                  //       " - ${bucketList.entries.elementAt(index).value}개",
                                                  //   style: Theme.of(context)
                                                  //       .textTheme
                                                  //       .headline4!
                                                  //       .copyWith(
                                                  //           color:
                                                  //               Colors.white),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: RichText(
                                              textAlign: TextAlign.right,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${bucketList.entries.elementAt(index).key.price}원 * ${(bucketList.entries.elementAt(index).value)} 개\n",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " ${(bucketList.entries.elementAt(index).value * bucketList.entries.elementAt(index).key.price!)}원",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    setState(() {
                                      Product removedProduct =
                                          //     bucketList.entries.firstWhere(
                                          //         (element) => element.key.id.toString() == direction.index.toString() orElse: "");
                                          bucketList.entries
                                              .elementAt(index)
                                              .key;
                                      bucketList.removeWhere((key, value) =>
                                          key.id == removedProduct.id);
                                      g.removeItemFromShoppingCart(
                                          removedProduct);
                                      log(direction.toString());
                                    });
                                  },
                                );
                              },
                            )
                          : Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 187, 187, 187)),
                                      top: BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 187, 187, 187))),
                                ),
                                margin: EdgeInsets.only(bottom: 10),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: "장사가 안되는 제 마음이 볶아지고 있습니다.\n",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  TextSpan(
                                      text: "오늘 커피 한잔 어떠세요?",
                                      style:
                                          Theme.of(context).textTheme.headline2)
                                ])),
                              ),
                            )),
                  Container(
                    alignment: Alignment.centerRight,
                    width: double.infinity,
                    height: 100,
                    // color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (bucketList.entries.length > 0)
                            ? Text(
                                "총 ${NumberFormat('#,###', 'ko_KR').format(bucketList.entries.where((element) => true).map((e) => e.key.price! * e.value).reduce((value, element) => value + element))} 원",
                                style: Theme.of(context).textTheme.headline3,
                              )
                            : Container()
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        if (g.loginMember.id != null && bucketList.isNotEmpty) {
                          OrderService()
                              .postOrder(g.loginMember.id!, bucketList)
                              .then((value) {
                            // log(value.toString());
                            if (value) {
                              g.shoppingCart.clear();
                              setState(() {
                                bucketList.clear();
                              });
                              g.toast("주문이 완료되었습니다");
                            }
                          });
                        } else {
                          g.toast("장바구니가 비어있습니다.");
                        }
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(5, 5),
                                  color: Color.fromARGB(255, 51, 121, 182))
                            ],
                            color: Color.fromARGB(255, 174, 177, 86),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Text(
                          "구매하기",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
