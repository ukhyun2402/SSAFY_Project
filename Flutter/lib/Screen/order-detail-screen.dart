import 'package:flutter/material.dart';
import 'package:main/Components/card-with-overflow-image-new.dart';
import 'package:main/Components/card-with-overflow-image.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? index = ModalRoute.of(context)?.settings.arguments.toString();

    return Scaffold(
        appBar: AppBar(
          title: Text("상세내역 $index"),
        ),
        body: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return CardWIthOverflowImageNew(
                customWidth: double.infinity,
              );
            }));
  }
}
