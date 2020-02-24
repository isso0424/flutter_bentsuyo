import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/without_static/data.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/types.dart';

class WordDetailRoot extends StatelessWidget{
  WordDetailRoot({
    this.wordIndex,
    this.wordsListIndex,
    this.word
  });
  final int wordIndex, wordsListIndex;
  final Words word;

  toLeft(widget) => Tools.toLeft(widget);
  getWidth(context) => Tools.getWidth(context);
  final _appBar = AppBar(title: Text("単語詳細"),);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _appBar,
      drawer: Tools.drawer(context),
      body: Padding(
        child: Column(
          children: <Widget>[
            toLeft(WordDetailTitle(word: word,)),
            Divider(),

            // 意味
            toLeft(Text("意味")),
            SizedBox(
              child: Card(
                child: Flex(
                  children: <Widget>[
                    Flexible(
                      child: WordDetailMean(word: word,),
                    )
                  ],
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
              width: getWidth(context) * 0.9,
              height: 200,
            ),

            // 詳細データ
            toLeft(Text("詳細")),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: Card(
                  child: WordDetailInfo(word: word,),
                ),
              ),
            ),

            // 単語削除ボタン
            _wordRemoveButton(context)
          ],
        ),
        padding: EdgeInsets.all(20.0),
      ),

    );
  }

  Widget _wordRemoveButton(BuildContext context){
    return RaisedButton(
      child: Text("単語の削除"),
      color: Colors.red,
      shape: StadiumBorder(),
      onPressed: (){
        WordsListData.removeWord(wordsListIndex, wordIndex);
        Navigator.of(context).pop();
      },
    );
  }
}

class WordDetailTitle extends StatefulWidget{
  WordDetailTitle({this.word});
  final Words word;

  @override
  _WordDetailTitleState createState() =>
      _WordDetailTitleState(word: word);
}

class _WordDetailTitleState extends State<WordDetailTitle>{
  _WordDetailTitleState({this.word});
  final Words word;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        word.word,
        style: TextStyle(fontSize: 25),
      ),
    );
  }
}

class WordDetailMean extends StatefulWidget{
  WordDetailMean({this.word});
  final Words word;
  @override
  _WordDetailMeanState createState() => _WordDetailMeanState(word: word);
}

class _WordDetailMeanState extends State<WordDetailMean>{
  _WordDetailMeanState({this.word});
  final Words word;
  @override
  Widget build(BuildContext context){
    return Text(
      word.mean,
      style: TextStyle(fontSize: 25),
    );
  }
}

class WordDetailInfo extends StatefulWidget{
  WordDetailInfo({this.word});
  final Words word;
  @override
  _WordDetailInfoState createState() =>
      _WordDetailInfoState(word: word);
}

class _WordDetailInfoState extends State<WordDetailInfo>{
  _WordDetailInfoState({this.word});
  final Words word;
  double correctPer;
  @override
  Widget build(BuildContext context) {
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
