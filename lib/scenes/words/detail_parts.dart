import 'package:flutter/material.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/data.dart';
import 'package:bentsuyo_app/tools/types.dart';

class WordsDetailMean extends StatefulWidget {
  @override
  _WordsDetailMeanState createState() => new _WordsDetailMeanState();
}

class WordsDetailTitle extends StatefulWidget {
  @override
  _WordsDetailTitleState createState() => new _WordsDetailTitleState();
}

class WordsDetailDetail extends StatefulWidget {
  @override
  _WordsDetailDetailState createState() => new _WordsDetailDetailState();
}

// 単語
class _WordsDetailTitleState extends State<WordsDetailTitle> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Text(
          HoldData.word.word,
          style: TextStyle(fontSize: 30),
        )
    );
  }
}

// 単語の意味
class _WordsDetailMeanState extends State<WordsDetailMean> {
  getWidth(context) => Tools.getWidth(context);
  @override
  Widget build(BuildContext context) {
    return Text(
      HoldData.word.mean,
      style: TextStyle(fontSize: 25),
    );
  }
}

// 単語の正答率などを含んだ詳細
class _WordsDetailDetailState extends State<WordsDetailDetail> {
  var correctPer;
  @override
  Widget build(BuildContext context) {
    Words word = HoldData.word;
    if (word.missCount + word.correct == 0) {
      correctPer = 0;
    } else {
      correctPer = (word.correct / (word.missCount + word.correct)) * 100;
    }
    return Column(
      children: <Widget>[
        Text(
          "正解数: ${word.correct}",
          style: TextStyle(fontSize: 20),
        ),
        Divider(),
        Text("誤答数: ${word.missCount}", style: TextStyle(fontSize: 20)),
        Divider(),
        Text("正答率: $correctPer %", style: TextStyle(fontSize: 20))
      ],
    );
  }
}
