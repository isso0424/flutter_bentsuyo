import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/tool.dart';

class WordsSearchView extends StatelessWidget{
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        toLeft(Text("単語帳検索")),
        Divider()
      ],
    );
  }
}