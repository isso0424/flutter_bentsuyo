import 'dart:core';

import 'package:bentsuyo_app/tools/data.dart';
import 'package:flutter/material.dart';
import '../tools/tool.dart';
import 'parts/words_parts.dart';

class WordsListRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Tools.drawer(context),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "単語帳リスト",
                  style: TextStyle(fontSize: 30),
                ),
                Divider(),
                Expanded(
                  child: WordsListList(),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Text(
          "+",
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new WordsListAdd()));
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class WordsListViewRoot extends StatelessWidget {
  WordsListViewRoot({this.index});
  int index;
  toLeft(widget) => Tools.toLeft(widget);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (_){
                    return AlertDialog(
                      title: Text("本当に削除していいですか?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("No"),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: (){
                            Navigator.of(context).pop(true);
                            HoldData.deleteWordsList();
                          },
                        )
                      ],
                    );
                  }
                ).then<void>((y){
                  if (y) Navigator.pop(context);
                }
                );
                HoldData.deleteWordsList();
                Navigator.pop(context);
              },
            )
          ],
        ),
        drawer: Tools.drawer(context),
        body: Column(
          children: <Widget>[
            WordsListTitle(),
            Divider(),
            toLeft(
                Text(
                  "　単語一覧",
                  style: TextStyle(fontSize: 30),
                )
            ),
            WordsListView(),
            TestButton(),
            toLeft(
                Text(
                  "　まだわかってない単語",
                  style: TextStyle(fontSize: 30),
                )
            ),
            ForgetWordsList(),
            TestButtonForgotWords()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Text(
            "+",
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new WordsAdd()));
          },
        )
    );
  }
}

// ignore: must_be_immutable
class DetailViewRoot extends StatelessWidget {
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Tools.drawer(context),
      body: Scaffold(
        body: Padding(
          child: Column(
            children: <Widget>[
              // タイトル
              toLeft(WordsDetailTitle()),
              Divider(),

              // 意味
              toLeft(Text("意味")),
              WordsDetailMean(),

              // 詳細データ(正答率など)
              toLeft(Text("詳細")),
              WordsDetailDetail(),

              // 単語削除ボタン
              _wordRemoveButton(context)
            ],
          ),
          padding: EdgeInsets.all(20.0),
        ),
      ),
    );
  }

  Widget _wordRemoveButton(BuildContext context){
    return RaisedButton(
      child: Text("単語の削除"),
      color: Colors.red,
      shape: StadiumBorder(),
      onPressed: () {
        HoldData.removeWord();
        Navigator.pop(context);
      },
    );
  }
}
