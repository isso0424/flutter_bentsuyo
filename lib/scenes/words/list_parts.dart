import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/data.dart';
import 'package:bentsuyo_app/tools/types.dart';

import 'detail.dart';
import 'test.dart';


// 単語帳のタイトル
class _WordsListTitleState extends State<WordsListTitle> {
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    String word = HoldData.wordsListList[HoldData.wordsListIndex].title;
    return toLeft(Text(
      word,
      style: TextStyle(fontSize: 40),
    ));
  }
}

// 単語帳の単語リスト
class _WordsListViewPartsState extends State<WordsListViewParts> {
  Widget toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadWordsList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Error!");
        } else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future loadWordsList() async {
    print("he");
    return ListView.builder(
      itemBuilder: (context, int index) {
        print(HoldData.wordsList.words[index] is Words);
        print(HoldData.wordsList.words[index]);
        if (!(HoldData.wordsList.words[index] is Words))
          HoldData.wordsList.words[index] =
              Words(
                  word: HoldData.wordsList.words[index]["word"],
                  mean: HoldData.wordsList.words[index]["mean"],
                  correct: HoldData.wordsList.words[index]["correct"],
                  missCount: HoldData.wordsList.words[index]["missCount"],
                  memorized: HoldData.wordsList.words[index]["memorized"]
              );
        print(HoldData.wordsList.words[index]);
        if (index == HoldData.wordsList.words.length) {
          print(HoldData.wordsList.words[index]);
          return GestureDetector(
            child: toLeft(Text(HoldData.wordsList.words[index].word)),
            onTap: () {
              HoldData.getWord(index);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailViewRoot()));
            },
          );
        }
        return Column(children: <Widget>[
          GestureDetector(
            child: toLeft(Text(HoldData.wordsList.words[index].word)),
            onTap: () {
              HoldData.getWord(index);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailViewRoot()));
            },
          ),
          Divider()
        ]);
      },
      itemCount: HoldData.wordsList.words.length,
    );
  }
}

// 忘れた単語のリスト
class _ForgetWordsListState extends State<ForgetWordsList> {
  getWidth(context) => Tools.getWidth(context);
  @override
  Widget build(BuildContext context) {
    HoldData.wordsList = HoldData.wordsListList[HoldData.wordsListIndex];
    bool notFoundForgotWord = true;
    for (var i in HoldData.wordsList.words) {
      if (i is Words ) {
        if (i.memorized) notFoundForgotWord = false;
      } else if (!i["memorized"]) {
        notFoundForgotWord = false;
      }

      if (!notFoundForgotWord) break;
    }

    // 単語帳完全理解者
    if (notFoundForgotWord) return Text("ないです");

    return ListView.builder(
      itemBuilder: (context, int index) {
        if (!(HoldData.wordsList.words[index] is Words))
          HoldData.wordsList.words[index] =
              Words(
                  word: HoldData.wordsList.words[index]["word"],
                  mean: HoldData.wordsList.words[index]["mean"],
                  correct: HoldData.wordsList.words[index]["correct"],
                  missCount: HoldData.wordsList.words[index]["missCount"],
                  memorized: HoldData.wordsList.words[index]["memorized"]
              );

        // indexが覚えていない単語のものか判定
        if (HoldData.wordsList.words[index].memorized) return Container();
        else return GestureDetector(
            child: Text(HoldData.wordsList.words[index].word),
            onTap: () {
              HoldData.getWord(index);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailViewRoot())
              );
            }
        );
      },
      itemCount: HoldData.wordsList.words.length,
    );
  }
}

class _TestButtonState extends State<TestButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("テストする"),
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                new WordsTestCore(HoldData.wordsListIndex, true)
            )
        )
    );
  }
}

class _TestButtonForgotWordsState extends State<TestButtonForgotWords> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("テストする"),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                new WordsTestCore(HoldData.wordsListIndex, false)));
      },
    );
  }
}

class _WordsAddState extends State<WordsAdd> {
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController wordController = new TextEditingController();
  final TextEditingController meanController = new TextEditingController();
  final TextEditingController tagController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(

            children:[ Padding(
              child: Column(
                children: <Widget>[
                  toLeft(Text(
                    "単語の追加",
                    style: TextStyle(fontSize: 20),
                  )),
                  toLeft(SizedBox(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "追加する単語",
                        hintText: "追加する単語を入力してください",
                      ),
                      controller: wordController,
                    ),
                    height: 100,
                    width: Tools.getWidth(context) * 0.9,
                  )),
                  toLeft(
                    SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "単語の意味",
                            hintText: "追加する単語の意味を入力してください"),
                        controller: meanController,
                      ),
                      height: 100,
                      width: Tools.getWidth(context) * 0.9,
                    ),
                  ),
                  RaisedButton(
                    child: Text("追加"),
                    shape: UnderlineInputBorder(),
                    onPressed: () {
                      String word = wordController.text;
                      String mean = meanController.text;
                      if (word == "" || mean == "") {
                        return;
                      }
                      HoldData.wordsList.words
                          .add(Words(
                          word:      word,
                          mean:      mean,
                          missCount: 0,
                          correct:   0,
                          memorized: false
                      ));
                      HoldData.wordsListList[HoldData.wordsListIndex] =
                          HoldData.wordsList;
                      HoldData.saveWordsListToLocal();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
            ),
            ]));
  }
}


class TestButton extends StatefulWidget {
  @override
  _TestButtonState createState() => _TestButtonState();
}

class ForgetWordsList extends StatefulWidget {
  @override
  _ForgetWordsListState createState() => new _ForgetWordsListState();
}

class WordsListTitle extends StatefulWidget {
  @override
  _WordsListTitleState createState() => new _WordsListTitleState();
}

// ignore: must_be_immutable
class WordsListViewParts extends StatefulWidget {
  @override
  _WordsListViewPartsState createState() => new _WordsListViewPartsState();
}

class TestButtonForgotWords extends StatefulWidget {
  @override
  _TestButtonForgotWordsState createState() =>
      _TestButtonForgotWordsState();
}


class WordsAdd extends StatefulWidget {
  @override
  _WordsAddState createState() => new _WordsAddState();
}
