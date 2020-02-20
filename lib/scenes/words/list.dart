import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/data.dart';
import 'list_parts.dart';

// ignore: must_be_immutable
class WordsListViewRoot extends StatelessWidget {
  WordsListViewRoot({this.index});
  int index;
  toLeft(widget) => Tools.toLeft(widget);
  getWidth(context) => Tools.getWidth(context);


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
            Container(
                child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: Card(
                            child: WordsListViewParts()
                        ),
                        height: 180,
                        width: getWidth(context) * 0.9,
                      )
                    ]
                )
            ),
            TestButton(),
            toLeft(
                Text(
                  "　まだわかってない単語",
                  style: TextStyle(fontSize: 30),
                )
            ),
            Container(
                child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: Card(
                            child: ForgetWordsList()
                        ),
                        height: 180,
                        width: getWidth(context) * 0.9,
                      )
                    ]
                )
            ),
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

