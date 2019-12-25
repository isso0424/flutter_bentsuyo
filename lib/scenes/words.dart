import 'dart:core';

import 'package:bentsuyo_app/tools/data.dart';
import 'package:flutter/material.dart';
import '../tools/tool.dart';
import 'parts/words_parts.dart';
import 'words_test.dart';

class WordsListRoot extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text("単語帳リスト",style: TextStyle(fontSize: 30),),
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
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new WordsListAdd()
          ));
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class WordsListViewRoot extends StatelessWidget{
  WordsListViewRoot({this.index});
  int index;
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          WordsListTitle(),
          Divider(),
          toLeft(Text("　単語一覧",
            style: TextStyle(fontSize: 30),)),
          WordsListView(),
          TestButton(),
          toLeft(Text("　まだわかってない単語", style: TextStyle(fontSize: 30),)),
          ForgetWordsList(),
          TestButtonDontMemorized()
        ],
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: (){
            Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) => new WordsAdd()
            ));
          },
        )
    );
  }
}

// ignore: must_be_immutable
class DetailViewRoot extends StatelessWidget{
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
        padding: EdgeInsets.all(20.0),),
      ),
    );
  }
}

class TestButton extends StatefulWidget {
  @override
   _TestButtonState createState() => _TestButtonState();
}

class _TestButtonState extends State<TestButton>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      child: Text("テストする"),
      onPressed: () => Navigator.push(context,
      MaterialPageRoute(
        builder: (BuildContext context) => new WordsTestCore(HoldData.wordsListIndex, true)
      ))
    );
  }
}

class TestButtonDontMemorized extends StatefulWidget{
  @override
  _TestButtonDontMemorizedState createState() => _TestButtonDontMemorizedState();
}

class _TestButtonDontMemorizedState extends State<TestButtonDontMemorized> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      child: Text("テストする"),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => new WordsTestCore(HoldData.wordsListIndex, false)
        ));
      },
    );
  }
  }
