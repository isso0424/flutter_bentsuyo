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

  static Widget drawer(BuildContext context){
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text("べんつよあぷり",
                style: TextStyle(fontSize: 30, color: Colors.white)),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text("たんごちょう"),
            onTap: (){
              Navigator.of(context).pushReplacementNamed("/w");
            },
          ),
          ListTile(
            title: Text("こうしき"),
            onTap: (){
              Navigator.of(context).pushReplacementNamed("/f");
            },
          ),
        ],
      ),
    );
  }
}

