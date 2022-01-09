import 'package:flutter/material.dart';

import 'clip-path.dart';

class CardWithDiagonal extends StatelessWidget {
  late String _category;
  late String _route;

  CardWithDiagonal({Key? key, required String category, required String route})
      : super(key: key) {
    _category = category;
    _route = route;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, _route, arguments: _category);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 184, 208, 147),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]),
        alignment: Alignment.center,
        child: Stack(children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 60),
            alignment: Alignment.centerLeft,
            child: Text(_category[0].toUpperCase() + _category.substring(1),
                style: Theme.of(context).textTheme.headline4),
          ),
          ClipPath(
            clipper: ClibPath(),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                margin: EdgeInsets.only(left: 30),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: AssetImage('asset/images/presents.jpg'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
        ]),
        width: 150,
        height: 100,
      ),
    );
  }
}
