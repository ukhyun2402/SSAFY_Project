import 'package:flutter/material.dart';
import 'package:main/userinfo.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';


class ProductDetial extends StatefulWidget {
  // const ProductDetial({Key? key}) : super(key: key);

  @override
  _ProductDetialState createState() => _ProductDetialState();
}

class _ProductDetialState extends State<ProductDetial> {
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

  BottomDrawerController _controller = BottomDrawerController();
  double _headerHeight = 100.0;
  double _bodyHeight = 500.0;
  int _amount = 0;

  Widget _buildBottomDrawer(BuildContext context) {
    return BottomDrawer(
      header: _buildBottomDrawerHead(context),
      body: _buildBottomDrawerBody(context),
      headerHeight: 0.0,
      drawerHeight: 500.0,
      color: Color(0xffffffff),
      controller: _controller,
      cornerRadius: 40.0,
    );
  }

  Widget _buildBottomDrawerHead(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0))),
      height: _headerHeight,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 15.0,
              bottom: 10.0,
            ),
            child: Column(
              children: [
                Text('메뉴 이름', style: drawerheaderStyle,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('가격:', style: drawerheaderStyle,),
                    SizedBox( width: 20,),
                    Text('price + 원', style: drawerheaderStyle,),
                  ],
                ),
              ],
            )
            // Text('메뉴 이름'),
          ),
          Spacer(),
          Divider(
            height: 1.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _bodyHeight,
      child: SingleChildScrollView(
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Image.asset('assets/minus.png', height: 30, color: Color(0xff9d0200)),
                onTap: () {
                  if (_amount > 0) {
                    setState(() {
                      _amount--;
                    });
                  }
                },
              ),
              SizedBox(width:5),
              Text(_amount.toString(), style: drawerlistStyle),
              SizedBox(width:5),
              InkWell(
                child: Image.asset('assets/add.png', height: 30, color: Color(0xff9d0200),),
                onTap: () {
                  setState(() {
                    _amount++;
                  });
                },
              ),
            ],
          )
        ]),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffF2EDE1),
      body: Container(
          child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: Image.asset(
                  'asset/images/coffee1_2.png',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        elevation: 0,
                        primary: Color(0xff1A1A1A),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        )),
                    onPressed: () {
                      print("구매하기 클릭됨");
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Folding()),
                      // );
                      _controller.open();
                    },
                    child: Text(
                      "구매하기",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildBottomDrawer(context),
        ],
      )),
      drawer: _drawer(context),
    );
  }
}
