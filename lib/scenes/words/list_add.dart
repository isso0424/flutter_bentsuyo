import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/data.dart';
import 'package:bentsuyo_app/tools/types.dart';

// 単語帳追加画面
class WordsListAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        child: WordsInfoInputter(),
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}

class WordsInfoInputter extends StatefulWidget{
  @override
  _WordsInfoInputterState createState() => new _WordsInfoInputterState();
}


// 単語帳追加画面のパーツ
class _WordsInfoInputterState extends State<WordsInfoInputter>{
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController tagController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        _textField(),

        [
          RaisedButton(
            child: Text("追加"),
            shape: UnderlineInputBorder(),
            onPressed: () {
              final input = _getInputResult();
              if (input["title"] == "" || input["tag"] == "") {
                return;
              }

              // 新しい単語帳を保存
              try {
                HoldData.wordsListList.add(WordsList(title: input["title"], tag: input["tag"], words: []));
              }catch(any){
                HoldData.wordsListList = [WordsList(title: input["title"],tag: input["tag"], words: [])];
              }
              HoldData.saveWordsListToLocal();

              Navigator.pop(context);
            },
          ),
        ]

      ].expand((widget) => widget).toList(),
    );
  }

  List<Widget> _textField(){
    return [toLeft(
        Text(
          "単語帳の追加",
          style: TextStyle(fontSize: 30),
        )
    ),
      toLeft(
          SizedBox(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "単語帳の名前",
                hintText: "単語帳の名前を入力してください",
              ),
              controller: titleController,
            ),
            height: 100,
            width: Tools.getWidth(context) * 0.85,
          )
      ),
      toLeft(
          SizedBox(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "タグ(1つ)",
                hintText: "タグを入力",
              ),
              controller: tagController,
            ),
            height: 100,
            width: Tools.getWidth(context) * 0.85,
          )
      ),
    ];
  }

  HashMap _getInputResult(){
    final m = HashMap();
    m["tag"] = tagController.text;
    m["title"] = titleController.text;
    return m;
  }
}

