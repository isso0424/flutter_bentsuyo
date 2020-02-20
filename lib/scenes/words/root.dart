import 'dart:core';

import 'package:bentsuyo_app/tools/data.dart';
import 'package:flutter/material.dart';
import '../../tools/tool.dart';
import 'list_add.dart';
import 'list.dart';

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
                  builder: (BuildContext context) => new WordsListAdd()
              )
          );
        },
      ),
    );
  }
}

class WordsListList extends StatefulWidget {
  @override
  _WordsListListState createState() => new _WordsListListState();
}

// WordsList一覧のListView
class _WordsListListState extends State<WordsListList> {
  @override
  Widget build(BuildContext context) {
    /*
    saveData("json", """
    [{"title":"単語帳", "tag":"たぐ", "words":[{"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":false}]}]
    """);
    */
    return FutureBuilder(
      future: getData("wordsListList"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Text("Error!");
        } else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future getData(String key) async {
    await HoldData.loadData(key);
    return ListView.builder(
        itemCount: HoldData.wordsListList.length,
        itemBuilder: (context, int index) {
          return GestureDetector(
            child: Card(
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Text(
                      HoldData.wordsListList[index].title,
                      style: TextStyle(fontSize: 30),
                    )
                  ]),
                  Row(
                      children: <Widget>[
                        Text(
                          "タグ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Card(
                            child: Text(
                              HoldData.wordsListList[index].tag,
                              style: TextStyle(fontSize: 20),
                            )
                        )
                      ]
                  )
                ],
              ),
            ),
            onTap: () {
              HoldData.wordsList = HoldData.wordsListList[index];
              HoldData.wordsListIndex = index;
              Navigator.push(
                  context,
                  new MaterialPageRoute<Null>(
                      builder: (BuildContext context) => WordsListViewRoot(
                        index: index,
                      )
                  )
              );
            },
          );
        }
        );
  }
  @override
  void initState() {
    super.initState();
  }
}
