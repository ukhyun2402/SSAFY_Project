import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:main/Components/card-with-overflow-image-new.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String category = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return CardWIthOverflowImageNew(
              customWidth: double.infinity,
              itemName: "NewOne",
              containerHeight: 100,
              onTabMethod: () {
                Navigator.pushNamed(context, '/order');
              },
            );
          }),
    );
  }
}
