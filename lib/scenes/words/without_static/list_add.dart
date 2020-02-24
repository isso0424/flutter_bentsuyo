import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/without_static/data.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/types.dart';

// 単語帳追加画面
class WordsListAdd extends StatelessWidget{
  final _appBar = AppBar(title: Text("単語帳の追加"),);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      drawer: Tools.drawer(context),
      body: Padding(
        child: WordsListInfoInputter(),
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}

class WordsListInfoInputter extends StatefulWidget{
  @override
  _WordsListInfoInputterState createState() => _WordsListInfoInputterState();
}

class _WordsListInfoInputterState extends State<WordsListInfoInputter>{
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController tagController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        toLeft(
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
                hintText: "単語帳の名前を入力してください"
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
                hintText: "タグを入力"
              ),
              controller: tagController,
            ),
            height: 100,
            width: Tools.getWidth(context) * 0.85,
          )
        ),
        RaisedButton(
          child: Text("追加"),
          shape: UnderlineInputBorder(),
          onPressed: () {
            if (titleController.text.trim() == ""
                || tagController.text.trim() == "") return;
            WordsListData.addNewWordsList(
                WordsList(
                    title: titleController.text,
                    tag: tagController.text,
                    words: []
                )
            );
            Navigator.pop(context);
          }
        )
      ],
    );
  }
}
