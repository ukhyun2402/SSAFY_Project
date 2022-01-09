import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:main/globals.dart' as g;

class SlideCard extends StatelessWidget {
  String _title = "";
  String? _subTitle = "";
  String? _imagePath = "";

  SlideCard({required title, subTitle, imagePath}) {
    // log(imagePath);
    this._title = title;
    this._subTitle = subTitle;
    this._imagePath = imagePath;
  }

  @override
  Widget build(BuildContext context) {
    // log(_imagePath.toString());
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(5, 5), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
              image: Image.network('${g.baseURL_image}${_imagePath}').image,
              fit: BoxFit.fill)),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("$_title", style: Theme.of(context).textTheme.headline3),
            Text("$_subTitle", style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
