import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:main/Components/drawer.dart';

class CustomScaffold extends StatefulWidget {
  final Widget body;
  final Color backgroundColor;

  CustomScaffold(
      {Key? key, required this.body, this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  TextStyle titleStyle = const TextStyle(
    fontFamily: "titan",
    fontSize: 30.0,
    color: Color(0xff1A1A1A),
    fontStyle: FontStyle.italic,
  );

  TextStyle drawerheaderStyle = const TextStyle(
    fontFamily: "titan",
    fontSize: 15.0,
    color: Color(0xff1A1A1A),
  );

  TextStyle drawerlistStyle = const TextStyle(
    fontSize: 20.0,
    color: Color(0xff1A1A1A),
  );

  double _headerHeight = 60.0;
  double _bodyHeight = 600.0;

  // Widget _buildBottomDrawerHead(BuildContext context) {
  //   return Container(
  //     height: _headerHeight,
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(
  //             left: 10.0,
  //             right: 10.0,
  //             top: 15.0,
  //           ),
  //           child: Text('기프트 카드 금액'),
  //         ),
  //         Spacer(),
  //         Divider(
  //           height: 1.0,
  //           color: Colors.grey,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildBottomDrawerBody(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     height: _bodyHeight,
  //     child: SingleChildScrollView(
  //       child: Column(children: [
  //         Text('구매하기'),
  //         Text('선물하기'),
  //       ]),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: widget.backgroundColor,
        body: widget.body,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/bucket');
          },
          tooltip: 'ShoppingCart',
          foregroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.shopping_cart),
          elevation: 10.0,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        // bottomNavigationBar: BottomAppBar(
        //   shape: const CircularNotchedRectangle(),
        //   color: Color.fromARGB(222, 213, 208, 200),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Expanded(
        //         child: IconButton(
        //           icon: Icon(Icons.card_giftcard),
        //           onPressed: () {
        //             Navigator.pushNamed(context, '/giftcard');
        //           },
        //         ),
        //       ),
        //       Expanded(child: Text('')),
        //       Expanded(
        //         child: IconButton(
        //           icon: Icon(Icons.shopping_cart_rounded),
        //           onPressed: () {},
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: CustomDrawer(context),
      );
}
