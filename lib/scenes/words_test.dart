import 'package:bentsuyo_app/scenes/parts/words_parts.dart';
import 'package:bentsuyo_app/tools/data.dart';
import 'package:bentsuyo_app/tools/types.dart';
import 'package:flutter/material.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class WordsTestCore extends StatelessWidget {
  WordsTestCore(int index, bool rememberFlag) {
    _index = index;
    this.rememberFlag = rememberFlag;
  }
  int _index;
  bool rememberFlag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: TestView(_index, rememberFlag)
        )
    );
  }
}

// ignore: must_be_immutable
class TestView extends StatefulWidget {
  TestView(index, rememberFlag) {
    _index = index;
    this.rememberFlag = rememberFlag;
  }
  int _index;
  bool rememberFlag;
  @override
  _TestViewState createState() => _TestViewState(_index, rememberFlag);
}

class _TestViewState extends State<TestView> {
  _TestViewState(int index, bool rememberFlag) {
    _index = index;
    this.rememberFlag = rememberFlag;
    HoldData.loadWordsList(_index);
    testCore = TestCore(HoldData.wordsList, this.rememberFlag);
    words = testCore.getWord();
    result = 2;
  }
  int _index;
  bool answeredFlag = false;
  int result;
  int questions;
  bool rememberFlag = false;
  TestCore testCore;
  int answerCount = 0;
  int missCount = 0;
  getWidth() => Tools.getWidth(context);
  Words words;
  final TextEditingController answerController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (answeredFlag) {
      String message;
      if (result == 0)
        message = "正解";
      else
        message = "不正解";
      return Column(
        children: <Widget>[
          WordsAnswerView(words: words, text: answerController.text, message: message,),
          RaisedButton(
            child: Text("次へ"),
            textColor: Colors.white,
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            onPressed: () {
              answeredFlag = false;
              if (result == 0)
                answerCount++;
              else
                missCount++;
              setState(() {});
            },
          )
        ],
      );
    } else {
      if (!answeredFlag && result != 2) {
        words = testCore.getWord();
        result = 2;
      }
      if (words.word != "0" || words.mean != "finish this test")
        return Column(
          children: <Widget>[
            Container(
                width: getWidth() * 0.9,
                height: getWidth() * 0.7,
                child: Card(child: Text(words.mean))),
            Divider(),
            Container(
              width: getWidth() * 0.7,
              height: getWidth() * 0.1,
              child: TextField(
                controller: answerController,
                decoration: InputDecoration(
                    labelText: "回答",
                    hintText: "意味に合う単語を入力してください",
                    border: OutlineInputBorder()),
              ),
            ),
            RaisedButton(
              child: Text("回答"),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () {
                if (words.word == answerController.text)
                  result = 0;
                else
                  result = 1;
                bool cache = false;
                if (result == 0)
                  cache = true;
                else
                  cache = false;
                HoldData.afterAnswer(words, cache);
                answeredFlag = true;
                setState(() {});
              },
            ),
          ],
        );
      else if (words.word == "404" &&
          words.mean == "you remember all words in words list")
        return AlertDialog(
          title: Text("エラー"),
          content: Text("テストする単語がありません"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      else
        return AlertDialog(
          title: Text("テスト終了"),
          content: Text("問題数 : ${answerCount + missCount}\n"
              "正解数 : $answerCount\n"
              "正答率 : ${answerCount / (answerCount + missCount) * 100}%"),
          actions: <Widget>[
            FlatButton(
              child: Text("Finish"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool updateManager() {
    if (!answeredFlag && result != 2) {
      result = 2;
      return (!answeredFlag && result != 2);
    } else
      return false;
  }
  // true == 0, false == 1, null == 2
}

class TestCore {
  var random = new math.Random();
  TestCore(WordsList wordsList, bool rememberFlag) {
    if (rememberFlag) {
      _words = new List<Words>();
      for (var value in wordsList.words) {
        _words.add(new Words(value["word"], value["mean"], value["missCount"],
            value["correct"], value["memorized"]));
      }
    } else {
      _words = new List<Words>();
      for (var value in wordsList.words) {
        if (value is Words) {
          if (!value.memorized) _words.add(value);
        } else if (!value["memorized"])
          _words.add(new Words(value["word"], value["mean"], value["missCount"],
              value["correct"], value["memorized"]));
      }
      if (_words.length == 0)
        _words.add(
            Words("404", "you remember all words in words list", 0, 0, false));
    }
  }
  List<Words> _words;
  Words getWord() {
    if (_words.length == 0) return Words("0", "finish this test", 0, 0, false);
    int index = random.nextInt(_words.length);
    Words word = _words[index];
    _words.removeAt(index);
    return word;
  }
}
