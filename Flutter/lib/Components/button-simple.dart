import 'package:flutter/material.dart';

class ButtonSimple extends StatelessWidget {
  String _text = "";
  IconData? _icon;
  late VoidCallback onTab;

  ButtonSimple({
    String text = "",
    Key? key,
    IconData? icon,
    required VoidCallback onTab,
  }) : super(key: key) {
    this._text = text;
    this._icon = icon;
    this.onTab = onTab;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onTab,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
            backgroundColor:
                MaterialStateProperty.all(Color.fromARGB(255, 169, 187, 213)),
            elevation: MaterialStateProperty.resolveWith<double>(
                (Set<MaterialState> states) {
              return 5.0;
            })),
        child: Container(
          // color: Colors.red,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "$_text",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              width: 15,
            ),
            // Icon(Icons.ac_unit),
            (_icon != null) ? Icon(_icon) : Container()
          ]),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        ),
      ),
    );
  }
}
