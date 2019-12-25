import 'package:flutter/material.dart';

class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}

class Tools {
  static Widget toLeft(Widget widget) {
    return Row(
      children: <Widget>[widget],
    );
  }

  static double getHeight(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return size.height;
  }

  static double getWidth(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return size.width;
  }
}
