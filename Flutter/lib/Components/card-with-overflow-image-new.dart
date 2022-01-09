import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:main/globals.dart' as g;

class CardWIthOverflowImageNew extends StatelessWidget {
  String _coffeeImgPath = '';
  double _customWidth = 200;
  double _containerHeight = 100;
  String _itemName = "";
  String _subTitle = '';
  VoidCallback _onTabMethod = () {};

  CardWIthOverflowImageNew(
      {String coffeeImgPath = 'asset/images/coffee1_2.png',
      required double customWidth,
      double? containerHeight,
      String itemName = '아메리카노',
      String subTitle = '',
      VoidCallback? onTabMethod}) {
    _coffeeImgPath = coffeeImgPath;
    _itemName = itemName;
    if (customWidth != null) {
      _customWidth = customWidth;
    }
    if (containerHeight != null) {
      _containerHeight = containerHeight;
    }
    _subTitle = subTitle;
    _onTabMethod = onTabMethod!;
  }

  @override
  Widget build(BuildContext context) {
    print(_containerHeight);
    return GestureDetector(
      onTap: _onTabMethod,
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 20, 10),
        width: _customWidth,
        height: _containerHeight,

        // color: Colors.red,
        child: Stack(children: [
          Column(
            children: [
              Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 5,
                child: Container(
                  // width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.only(left: 24, right: 80),
                  alignment: Alignment.centerLeft,

                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _itemName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: Colors.black, letterSpacing: 0.6),
                        ),
                        Text(
                          _subTitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: Colors.black, letterSpacing: 0.6),
                        ),
                      ]),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromARGB(255, 237, 224, 237),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(4, 5), // changes position of shadow
                        ),
                      ]),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Spacer(
                flex: 3,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  // color: Colors.blue,
                  //     image: DecorationImage(
                  // image: Image.network('${g.baseURL_image}${_imagePath}').image,
                  // fit: BoxFit.fill)),
                  child: Image(
                    image: Image.network('${g.baseURL_image}${_coffeeImgPath}')
                        .image,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
