import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/without_static/data.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/types.dart';

import 'dart:math' as math;

class WordsTestCore extends StatefulWidget{
  WordsTestCore({this.wordsList, this.remember, this.index});
  final WordsList wordsList;
  final bool remember;
  final int index;
  @override
  _WordsTestCoreState createState() =>
    _WordsTestCoreState(wL: wordsList, remember: remember, index: index);
}

class _WordsTestCoreState extends State<WordsTestCore>{
  _WordsTestCoreState({this.wL, this.remember, this.index});
  WordsList wL;
  final int index;
  final bool remember;

  final TextEditingController answerController = new TextEditingController();

  int wordNumber = 1;
  int questionsCount;
  int correctCount = 0;
  int wordIndex;
  String _userAnswer = "";
  bool checkAnswer = false;
  bool reloadWord = true;
  bool result;
  math.Random random = math.Random();
  List<Words> wordsList;
  Words nowWord;

  getWidth(context) => Tools.getWidth(context);
  getHeight(context) => Tools.getHeight(context);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("$wordNumber / $questionsCount問目"),),
      body: checkAnswer ? checkAnswerView(context): questionView(context),
    );
  }

  Widget questionView(BuildContext context){
    // 単語が無い単語帳を参照した場合ダイアログを出す
    if (questionsCount == 0){
      return AlertDialog(
        title: Text("単語がありません"),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }

    // 最後の問題を回答し終えたら結果を出す
    if (questionsCount + 1 == wordNumber){
      WordsListData.refreshWordsList(index, wL);
      return resultView(context);
    }

    // 単語のロード
    if (reloadWord) {
      wordIndex = random.nextInt(wordsList.length);
      nowWord = wordsList[wordIndex];
      wordsList.removeAt(wordIndex);
      int cache = 0;
      for (Words w in wL.words){
        if (w == nowWord) break;
        cache++;
      }
      wordIndex = cache;
      reloadWord = false;
    }
    return Column(
      children: <Widget>[
        Container(
          width: getWidth(context) * 0.9,
          height: getHeight(context) * 0.4,
          child: Card(
            child: Text(nowWord.word),
          ),
        ),
        Divider(),
        Container(
          width: getWidth(context) * 0.7,
          height: getHeight(context) * 0.1,
          child: TextField(
            controller: answerController,
            decoration: InputDecoration(
              labelText: "回答",
              hintText: "意味に合う単語を入力してください",
              border: OutlineInputBorder()
            ),
          ),
        ),
        RaisedButton(
          child: Text("回答"),
          color: Colors.orange,
          textColor: Colors.white,
          onPressed: (){
            if (answerController.text.trim() == "") return;
            _userAnswer = answerController.text;
            result = nowWord.word ==_userAnswer;
            checkAnswer = true;
            if (result) {
              wL.words[wordIndex].correct++;
              correctCount++;
            }
            else wL.words[wordIndex].missCount++;
            int c = wL.words[wordIndex].correct;
            int m = wL.words[wordIndex].missCount;
            wL.words[wordIndex].memorized = (c / (c + m) > 0.5);
            setState((){});
          },
        )
      ],
    );
  }

  Widget resultView(BuildContext context){
    return Center(
      child: AlertDialog(
        title: Text("テスト終了"),
        content: Text(
            "問題数 : $questionsCount\n"
                "正解数 : $correctCount\n"
                "正答率 : ${correctCount / questionsCount * 100}"
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Finish"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Widget checkAnswerView(BuildContext context){
    reloadWord = true;
    return Column(
      children: <Widget>[
        Text(
          result ? "正解" : "不正解",
          style: TextStyle(fontSize: 15),
        ),
        Divider(),
        Text(
          "模範解答 : ${nowWord.word}"
          "あなたの回答 $_userAnswer"
        ),
        Container(
          child: Card(
            child: Text("意味 : ${nowWord.mean}"),
          ),
        ),
        RaisedButton(
          child: Text("次へ"),
          textColor: Colors.white,
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)
          ),
          onPressed: (){
            checkAnswer = false;
            wordNumber++;
            setState(() {});
          },
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    questionsCount = wL.words.length;
    List<Words> w = new List.from(wL.words);
    wordsList = [];
    if (!remember){
      for (Words word in w){
        if (!word.memorized) wordsList.add(word);
      }
    }
    else wordsList = w;
  }

}

class TestButton extends StatefulWidget{
  TestButton({this.index});
  final int index;

  @override
  _TestButtonState createState() => _TestButtonState(
    index: index
  );
}

class _TestButtonState extends State<TestButton>{
  _TestButtonState({this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _reloadButton(),
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot
      ){
        if (snapshot.hasData){
          return snapshot.data;
        }else if (snapshot.hasError){
          return
            Card(
              child: Text(
                  "Error Occled!!!\nDetail is this.\n${snapshot.error}"
              )
            );
        }else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future _reloadButton() async{
    WordsList wordsList = (await WordsListData.loadWordsListList())[index];
    return RaisedButton(
      child: Text("テストする"),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
              new WordsTestCore(
                wordsList: wordsList,
                index: index,
                remember: true,
              )
          )
      ),
    );
  }
}

class ForgetTestButton extends StatefulWidget{
  ForgetTestButton({this.index});
  final int index;

  @override
  _ForgetTestButtonState createState() => _ForgetTestButtonState(
      index: index
  );
}

class _ForgetTestButtonState extends State<ForgetTestButton>{
  _ForgetTestButtonState({ this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _reloadButton(),
      builder: (
          BuildContext context,
          AsyncSnapshot snapshot
          ){
        if (snapshot.hasData){
          return snapshot.data;
        }else if (snapshot.hasError){
          return
            Card(
                child: Text(
                    "Error Occled!!!\nDetail is this.\n${snapshot.error}"
                )
            );
        }else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  Future _reloadButton() async {
    WordsList wordsList = (await WordsListData.loadWordsListList())[index];
    return RaisedButton(
      child: Text("テストする"),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () =>
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new WordsTestCore(
                    wordsList: wordsList,
                    index: index,
                    remember: false,
                  )
              )
          ),
    );
  }
}