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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text("べんつよあぷり",
                  style: TextStyle(fontSize: 30, color: Colors.white)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("たんごちょう"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed("/w");
              },
            ),
            ListTile(
              title: Text("こうしき"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed("/f");
              },
            ),
          ],
        ),
      ),
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
                HoldData.deleteWordsList();
                Navigator.pop(context);
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text("べんつよあぷり",
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                decoration: BoxDecoration(color: Colors.blue),
              ),
              ListTile(
                title: Text("たんごちょう"),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed("/w");
                },
              ),
              ListTile(
                title: Text("こうしき"),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed("/f");
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            WordsListTitle(),
            Divider(),
            toLeft(Text(
              "　単語一覧",
              style: TextStyle(fontSize: 30),
            )),
            WordsListView(),
            TestButton(),
            toLeft(Text(
              "　まだわかってない単語",
              style: TextStyle(fontSize: 30),
            )),
            ForgetWordsList(),
            TestButtonDontMemorized()
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
        ));
  }
}

// ignore: must_be_immutable
class DetailViewRoot extends StatelessWidget {
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text("べんつよあぷり",
                  style: TextStyle(fontSize: 30, color: Colors.white)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("たんごちょう"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed("/w");
              },
            ),
            ListTile(
              title: Text("こうしき"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed("/f");
              },
            ),
          ],
        ),
      ),
      body: Scaffold(
        body: Padding(
          child: Column(
            children: <Widget>[
              toLeft(WordsDetailTitle()),
              Divider(),
              toLeft(Text("意味")),
              WordsDetailMean(),
              toLeft(Text("詳細")),
              WordsDetailDetail(),
              RaisedButton(
                child: Text("単語の削除"),
                color: Colors.red,
                shape: StadiumBorder(),
                onPressed: () {
                  HoldData.removeWord();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          padding: EdgeInsets.all(20.0),
        ),
      ),
    );
  }
}
