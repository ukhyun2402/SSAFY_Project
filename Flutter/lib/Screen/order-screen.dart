import 'dart:developer';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:main/Components/custom-scaffold.dart';
import 'package:main/model/Member.dart';
import 'package:main/model/Product.dart';
import 'package:main/service/MemberService.dart';
import 'package:main/service/ProductService.dart';
import 'package:main/globals.dart' as g;
import 'package:main/service/ReviewService.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  //BOTTOM DRAWER
  BottomDrawerController _controller = BottomDrawerController();
  late List<dynamic> _products;

  bool drawerVisible = false;
  int selectedProductId = -1;

  int productOrderQuantity = 0;

  Widget _buildBottomDrawer(BuildContext context, VoidCallback _onTab) {
    return Stack(children: [
      Visibility(
        visible: (drawerVisible),
        child: GestureDetector(
          onTap: () {
            _onTab();
            _controller.close();
            productOrderQuantity = 0;
          },
          child: Container(
            // color: Colors.white,
            color: Color.fromARGB(105, 0, 0, 0),
          ),
        ),
      ),
      BottomDrawer(
        callback: (value) {
          if (value == false) {
            _onTab();
            productOrderQuantity = 0;
          }
        },
        header: Stack(children: [
          _buildBottomDrawerHead(context),
          // Positioned(
          //   top: 0,
          //   // bottom: 30,
          //   child: Container(
          //     // margin: EdgeInsets.only(bottom: 20),
          //     // padding: EdgeInsets.only(bottom: 20),
          //     width: 50,
          //     height: 50,
          //     // color: Colors.black,
          //   ),
          // )
        ]),
        body: _buildBottomDrawerBody(context),
        headerHeight: 0.0,
        drawerHeight: MediaQuery.of(context).size.height * 0.8,
        // color: Colors.red,
        cornerRadius: 25,
        controller: _controller,
      ),
    ]);
  }

  Widget _buildBottomDrawerHead(BuildContext context) {
    return Container(
      height: 150,
      // width: double.infinity,

      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 161, 155, 155),
              offset: Offset(0, -5),
            )
          ],
          color: Color.fromARGB(255, 236, 230, 230),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: (selectedProductId != -1)
            ? [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(5, 5),
                            color: Color.fromARGB(255, 67, 62, 62))
                      ],
                      color: Color.fromARGB(255, 249, 197, 42),
                      shape: BoxShape.circle),
                  margin: EdgeInsets.only(left: 20),
                  child: Image.network(
                      "${g.baseURL_image}${_products[selectedProductId]['productImgPath']}"),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 45),
                  child: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline2,
                        children: [
                          TextSpan(
                            text: "\n${_products[selectedProductId]['price']}원",
                          )
                        ],
                        text: "${_products[selectedProductId]['productName']}"),
                  ),
                )
              ]
            : [
                Container(
                  child: Text("ERRORROORORERRROEERRROOO"),
                )
              ],
      ),
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    return Container(
      // color: Colors.blue,
      color: Color.fromARGB(255, 236, 230, 230),
      // margin: EdgeInsets.only(top: 30),
      width: double.infinity,
      height: 700,
      child: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          productOrderQuantity++;
                        });
                      },
                      child: Container(
                        child: Icon(Icons.remove),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$productOrderQuantity",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          productOrderQuantity++;
                        });
                      },
                      child: Container(
                          child: Icon(
                        Icons.add,
                      )),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.only(left: 20, bottom: 20),
              alignment: Alignment.centerLeft,
              child: (selectedProductId != -1)
                  ? Text(
                      "다른 분들은 ${_products[selectedProductId]['productName']}에  😛 \n대해서 이렇게 생각하고있어요!",
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.left,
                    )
                  : Container()),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            // color: Color.fromARGB(255, 172, 99, 99),
            height: 250,
            child: (selectedProductId != -1)
                ? FutureBuilder(
                    future: ReviewService().getReviews(selectedProductId + 1),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return CircularProgressIndicator();
                      } else {
                        var reviews = (snapshot.data as List<dynamic>);
                        // log(reviews.toString());
                        // log(reviews.length.toString());
                        return ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return ListTile(
                            //   leading: CircleAvatar(),
                            //   tileColor: Colors.red,
                            //   title: Text(reviews[index]['content']),
                            //   subtitle:
                            //       Text(reviews[index]['memberId'].toString()),
                            // );
                            return FutureBuilder(
                                future: MemberService()
                                    .getMember(reviews[index]['memberId']),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData == false) {
                                    return CircularProgressIndicator();
                                  } else {
                                    var memberImgPath =
                                        (snapshot.data as Member).img ??
                                            "/1.png";
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: Image.network(
                                                    "${g.baseURL_image}${memberImgPath}")
                                                .image,
                                          ),
                                          title: Text(
                                            reviews[index]['content'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    );
                                  }
                                });
                          },
                        );
                      }
                    },
                  )
                : Container(),
          ),
          ElevatedButton(
            onPressed: () {
              // log(productOrderQuantity.toString());
              // log(selectedProductId.toString());
              if (productOrderQuantity <= 0) {
                g.toast("0개 이하는 장바구니에 담을 수 없습니다");
              } else {
                ProductService()
                    .getProduct(selectedProductId + 1)
                    .then((value) {
                  g.addShoppingCart(value!, productOrderQuantity);
                  g.toast(
                      "장바구니에 ${value.productName} ${productOrderQuantity}개를 담았습니다.");
                  g.shoppingCart.forEach((key, value) {
                    log(key.productName! + " => " + value.toString());
                  });
                  setState(() {
                    drawerVisible = false;
                    _controller.close();
                    productOrderQuantity = 0;
                  });
                }).onError((error, stackTrace) {
                  log(error.toString());
                });
              }
            },
            child: Container(
                width: double.infinity,
                child: Text(
                  "장바구니에 담기",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                )),
          )
        ]),
      ),
    );
  }

  void initState() {
    super.initState();
    ProductService().getProducts().then((value) {
      _products = (value as List<dynamic>);
      productSelect();
    });
  }

  @override
  void productSelect() {
    int productId =
        int.parse(ModalRoute.of(context)!.settings.arguments.toString());
    if (productId > 0) {
      setState(() {
        selectedProductId = productId - 1;
        drawerVisible = !drawerVisible;
        _controller.open();
        // log(selectedProductId.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bottomDrawerToggle = () {
      setState(() {
        drawerVisible = !drawerVisible;
      });
    };
    //product argument

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 247, 247),
      floatingActionButton: (drawerVisible)
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                // Navigator.restorablePushNamedAndRemoveUntil(
                //     context, '/bucket', ModalRoute.withName('/order'));
                // Navigator.restorablePushNamed(context, '/bucket');
                Navigator.pushReplacementNamed(context, '/bucket');
              },
              tooltip: 'Main',
              foregroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.shopping_cart),
              elevation: 10.0,
              backgroundColor: Theme.of(context).backgroundColor,
            ),
      body: WillPopScope(
        onWillPop: () {
          if (drawerVisible) {
            bottomDrawerToggle();
            _controller.close();
            productOrderQuantity = 0;
            return Future(() => false);
          } else {
            return Future(() => true);
          }
        },
        child: SafeArea(
            child: Stack(
          children: [
            Positioned(
                top: -80,
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(136, 255, 209, 152)),
                )),
            // Positioned(
            //     top: -60,
            //     right: -120,
            //     child: Container(
            //       width: 320,
            //       height: 320,
            //       decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Color.fromARGB(134, 181, 162, 22)),
            //     )),
            Container(
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              // margin: EdgeInsets.only(top: 20),

              child: FutureBuilder(
                future: ProductService().getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    //       // log(snapshot.data.toString());
                    var products = (snapshot.data as List<dynamic>);
                    _products = products;

                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "돌멩이 커피에서    💑\n최고의 커피를 맛보세요  ",
                            style: Theme.of(context).textTheme.headline3,
                            textAlign: TextAlign.start,
                          ),
                          margin: EdgeInsets.only(bottom: 16),
                        ),
                        Expanded(
                          // margin: EdgeInsets.fromLTRB(45, 32, 45, 10),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 30,
                                    mainAxisSpacing: 30),
                            itemCount: _products.length,
                            itemBuilder: (BuildContext context, int index) {
                              double bottomMargin = 30;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedProductId = index;
                                  });
                                  log("product clicekd");
                                  bottomDrawerToggle();
                                  _controller.open();
                                },
                                child: Stack(children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsets.only(bottom: bottomMargin),
                                    decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 252, 162, 114),
                                            offset: Offset(4, 4),
                                          )
                                        ],
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromARGB(255, 255, 228, 219)),
                                  ),
                                  Container(
                                    // color: Colors.red,
                                    padding: EdgeInsets.all(5),
                                    margin:
                                        EdgeInsets.only(bottom: bottomMargin),
                                    alignment: Alignment.topCenter,
                                    child: Image.network(
                                      "${g.baseURL_image}${_products[index]['productImgPath']}",
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      _products[index]['productName'],
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  )
                                ]),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            _buildBottomDrawer(context, bottomDrawerToggle),
          ],
        )),
      ),
    );
  }
}
