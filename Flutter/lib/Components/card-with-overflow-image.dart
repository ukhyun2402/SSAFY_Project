import 'package:flutter/material.dart';

class CardWIthOverflowImage extends StatelessWidget {
  late String _coffeeImgPath;
  double? _customWidth;
  late String _itemName;

  CardWIthOverflowImage({
    String coffeeImgPath = 'asset/images/coffee1_2.png',
    double? customWidth,
    String itemName = "",
  }) {
    _coffeeImgPath = coffeeImgPath;
    _itemName = itemName;
    if (customWidth != null) {
      _customWidth = customWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: 250,
          height: 200,
          child: Stack(
            children: [
              // 보이는 배경
              Positioned(
                right: 0,
                bottom: 0,
                width: 250,
                height: 180,
                child: Container(
                  alignment: Alignment.centerLeft,
                  // padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                  decoration: BoxDecoration(
                      color: Color(0xFFDBD0C0),
                      // color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(4, 8))
                      ]),
                ),
              ),

              //이미지
              Positioned(
                top: 0,
                right: 0,
                height: 180,
                child: Container(
                  alignment: Alignment.topRight,
                  // color: Colors.green,
                  child: Image(
                    image: AssetImage(
                      _coffeeImgPath,
                    ),
                    fit: BoxFit.fitHeight,
                    // filterQuality: FilterQuality.low,
                  ),
                ),
              ),

              // 텍스트
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        (_itemName == "")
                            ? Text(
                                "Latte",
                                style: TextStyle(
                                  fontFamily: 'TitanOne',
                                  fontSize: 27,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Text(
                                "$_itemName",
                                style: TextStyle(
                                  fontFamily: 'TitanOne',
                                  fontSize: 27,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
