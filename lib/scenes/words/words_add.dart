import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/without_static/data.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/types.dart';

class WordAddViewRoot extends StatelessWidget{
  WordAddViewRoot({this.wordsListIndex});
  final int wordsListIndex;

  toLeft(widget) => Tools.toLeft(widget);
  final _appBar = AppBar(title: Text("単語の追加"));

  @override
  Widget build(context){
    return Scaffold(
      appBar: _appBar,
      drawer: Tools.drawer(context),
      body: ListView(
        children: <Widget>[
          Padding(
            child: WordAddViewParts(
              wordsListIndex: wordsListIndex,
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ],
      ),
    );
  }
}

class WordAddViewParts extends StatefulWidget{
  WordAddViewParts({this.wordsListIndex});
  final int wordsListIndex;

  @override
  _WordAddViewPartsState createState() =>
      _WordAddViewPartsState(wordsListIndex: wordsListIndex);
}

class _WordAddViewPartsState extends State<WordAddViewParts>{
  _WordAddViewPartsState({this.wordsListIndex});
  final int wordsListIndex;

  final TextEditingController wordController = new TextEditingController();
  final TextEditingController meanController = new TextEditingController();

  toLeft(widget) => Tools.toLeft(widget);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        toLeft(
          Text(
            "単語の追加",
            style: TextStyle(fontSize: 20),
          )
        ),
        toLeft(
          SizedBox(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "追加する単語",
                hintText: "追加する単語を入力してください"
              ),
              controller: wordController,
            ),
            height: 100,
            width: Tools.getWidth(context) * 0.9,
          )
        ),
        toLeft(
          SizedBox(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "単語の意味",
                hintText: "追加する単語の意味を入力してください"
              ),
              controller: meanController,
            ),
            height: 100,
            width: Tools.getWidth(context) * 0.9,
          )
        ),
        RaisedButton(
          child: Text("追加"),
          shape: UnderlineInputBorder(),
          onPressed: () async{
            String word = wordController.text;
            String mean = meanController.text;
            if (word == "" || mean == "") return;
            await WordsListData.addToWordsList(
              wordsListIndex,
              Words(
                word: word,
                mean: mean,
                correct: 0,
                missCount: 0,
                memorized: false
              )
            );
            print("hoy");
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
