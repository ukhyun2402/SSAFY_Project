import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class RoulettEvent extends StatefulWidget {
  @override
  _RoulettEventState createState() => _RoulettEventState();
}

class _RoulettEventState extends State<RoulettEvent> {
  TextStyle titleStyle = TextStyle(
    fontFamily: "titan",
    fontSize: 30.0,
    color: Color(0xff1A1A1A),
    fontStyle: FontStyle.italic,
  );

  TextStyle wheelListStyle = TextStyle(
    fontFamily: "Gowun",
    fontSize: 15.0,
    color: Colors.white,
  );

  StreamController<int> _controller = StreamController<int>();

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    String gotIt = '';
    String contents = '';

    final items = <String>[
      '꽝',
      '기프트카드 5000원권',
      '아메리카노 1잔',
      '꽝',
      '2022 다이어리',
      '꽝',
      '디저트 1개 교환권',
      '음료 1개 교환권',
      '꽝',
      '멤버십 한 단계 상승권',
    ];

    return Scaffold(
      backgroundColor: Color(0xffF2EDE1),
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 70,
          ),
          Text(
            " Event",
            style: titleStyle,
          ),
          Flexible(
            child: Center(
                child: Column(
              children: [
                Text(
                  'Fortune Wheel',
                  style: titleStyle.copyWith(fontSize: 15),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        print("Selected value: $selected ${items[selected]}");
                        _controller.add(
                          selected = Fortune.randomInt(0, items.length),
                        );
                        gotIt = items[selected].toString();
                        print('- ontap');
                        print(selected);
                        print(gotIt);
                      });
                    },
                    child: Expanded(
                      child: FortuneWheel(
                        selected: _controller.stream,
                        items: [
                          for (var it in items)
                            FortuneItem(
                              child: Text(
                                it,
                                style: wheelListStyle,
                              ),
                            ),
                        ],
                        onAnimationEnd: () {
                          gotIt = items[selected].toString();
                          if (gotIt == '꽝') {
                            contents = '꽝 입니다. \n다음 기회에 다시 도전해주세요.';
                          } else {
                            contents =
                                gotIt + ' 당첨되었습니다.\n회원정보 [쿠폰]에서 확인 하실 수 있습니다.';
                          }
                          showDialog(
                              context: context,
                              barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    '당첨 결과',
                                    style: wheelListStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          contents,
                                          style: wheelListStyle.copyWith(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        '확인',
                                        style: wheelListStyle.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        indicators: <FortuneIndicator>[
                          FortuneIndicator(
                            alignment: Alignment.topCenter,
                            child: TriangleIndicator(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ]),
      ),
    );
  }
}
