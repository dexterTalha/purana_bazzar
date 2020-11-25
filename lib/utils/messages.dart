import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/constants.dart';

class Message extends StatelessWidget {
  Message({this.msg, this.direction, this.dateTime});

  final String msg;
  final String direction;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: direction == 'left'
          ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      //for left corner

                      Image.asset(
                        'assets/png/in.png',
                        fit: BoxFit.scaleDown,
                        width: 30.0,
                        height: 30.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 6.0),
                        decoration: BoxDecoration(
                          color: Color(0xffd6d6d6),
                          border: Border.all(
                            color: Color(0xffd6d6d6),
                            width: .25,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            topLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        width: size.width * 0.6,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg,
                              softWrap: true,
                              textDirection: TextDirection.ltr,
                              maxLines: 100,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xff000000),
                              ),
                            ),
                            Text(
                              dateTime,
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[

                        Container(
                          margin: EdgeInsets.only(right: 6.0),
                          width: size.width * 0.6,
                          decoration: BoxDecoration(
                            color: mPrimaryDarkColor,
                            border: Border.all(
                                color: mPrimaryDarkColor,
                                width: .25,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5.0),
                              topLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                            ),
                          ),
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                dateTime,
                                style: TextStyle(
                                  fontSize: 8.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
