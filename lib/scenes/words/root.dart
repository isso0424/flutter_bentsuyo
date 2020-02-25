import 'dart:core';

import 'package:flutter/material.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/without_static/data.dart';
import 'package:bentsuyo_app/tools/types.dart';

import 'list.dart';
import 'list_add.dart';

class WordsListRoot extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              /*
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => WordsSearchViewRoot()
                  )
              );

               */
            },
          ),
        ],
      ),
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
        onPressed: (){
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

class WordsListList extends StatefulWidget{
  @override
  _WordsListListState createState() => new _WordsListListState();
}

class _WordsListListState extends State<WordsListList>{
  List<WordsList> wordsListList;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.hasData){
          return snapshot.data;
        } else if (snapshot.hasError){
          return Text("Error!\n${snapshot.error}");
        } else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future getData() async{
    print("hey");
    wordsListList = await WordsListData.loadWordsListList();
    print("hi");
    return ListView.builder(
      itemCount: wordsListList.length,
      itemBuilder: (context, int index){
        return GestureDetector(
          child: Card(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      wordsListList[index].title,
                      style: TextStyle(fontSize: 30),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "タグ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Card(
                      child: Text(
                        wordsListList[index].tag,
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          onTap: (){
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new WordsListViewRoot(
                  wordsList: wordsListList[index],
                  wordsListIndex: index,
                )
              )
            );
          },
        );
      },
    );
  }
}
