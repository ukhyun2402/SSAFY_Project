import 'package:flutter/material.dart';
import 'package:main/Screen/order-detail-screen.dart';

class OrderedListScreen extends StatefulWidget {
  OrderedListScreen({Key? key}) : super(key: key);

  @override
  _OrderedListScreenState createState() => _OrderedListScreenState();
}

class _OrderedListScreenState extends State<OrderedListScreen> {
  List cards = List.generate(10, (index) => OrderedCard(index: index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "주문내역",
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Color(0xFFDBD0C0),
      ),
      body: SafeArea(child:
          ListView.builder(itemBuilder: (BuildContext context, int index) {
        if (cards.length > 0) {
          return OrderedCard(index: index);
        } else {
          return Text("Nothing...");
        }
      })),
    );
  }
}

class OrderedCard extends StatefulWidget {
  late int index;

  OrderedCard({
    Key? key,
    required int index,
  }) : super(key: key) {
    this.index = index;
  }

  @override
  State<OrderedCard> createState() => _OrderedCardState();
}

class _OrderedCardState extends State<OrderedCard> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
          color: Color(0xFFF2EDE1),
          child: Column(
            children: [
              ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.coffee_rounded,
                    ),
                  ),
                  // onTap:
                  // () {

                  // },
                  title: Text("아메리카노 외 3잔 "),
                  subtitle: Text("2021-01-29 16:24"),
                  trailing: GestureDetector(
                    child: Text("상세내역보기"),
                    onTap: () {
                      Navigator.pushNamed(context, '/order-detail',
                          arguments: widget.index);
                      print(widget.index);
                    },
                  )),
            ],
          )),
    );
  }
}
