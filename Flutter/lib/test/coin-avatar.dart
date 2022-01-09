import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isShow = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lottie Flutter'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Visibility(
                    visible: _isShow,
                    child: Container(
                      width: 10,
                      height: 10,
                      color: Colors.red,
                    )),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _isShow = true;
                      });
                    },
                    child: Text('Show Lottie'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _isShow = false;
                      });
                    },
                    child: Text('Hide Lottie'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
