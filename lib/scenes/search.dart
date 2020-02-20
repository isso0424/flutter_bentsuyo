import 'dart:collection';
import 'dart:core';
import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/types.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/data.dart';

import 'words/list.dart';

class WordsSearchViewRoot extends StatefulWidget{
  @override
  WordsSearchViewRootState createState() => WordsSearchViewRootState();
}

// ignore: must_be_immutable
class WordsSearchViewRootState extends State<WordsSearchViewRoot>{
  static String inputKeyWord = "";
  static bool searchView = false;
  static bool searchWithTag = true;
  toLeft(widget) => Tools.toLeft(widget);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Tools.drawer(context),
      body: searchView ? SearchResults() : InputView(),
    );
  }

  static Future search() async{
    var searchResults = HashMap();
    searchResults["wordsList"] = [];
    searchResults["index"] = [];
    int index = 0;
    await HoldData.loadData("wordsListList");
    if (searchWithTag) {
      for (var wordsL in HoldData.wordsListList) {
        if (wordsL is WordsList) {
          if (wordsL.tag == inputKeyWord) {
            searchResults["wordsList"].add(wordsL);
            searchResults["index"].add(index);
          }
        }else{
          if (wordsL["tag"] == inputKeyWord){
            searchResults["wordsList"] =
                  WordsList(
                      title: wordsL["title"],
                      tag:   wordsL["tag"],
                      words: wordsL["words"]
                  );
            searchResults["index"] = index;
          }
        }
        index++;
      }
    }
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index){
        return GestureDetector(
          child: Card(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      searchResults[index][0].title,
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "タグ",
                      style: TextStyle(fontSize: 30),
                    ),
                    Card(
                      child: Text(
                        searchResults[index][0].tag,
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          onTap: (){
            HoldData.getWordsListIndex(searchResults["index"][index]);
            HoldData.wordsListIndex = searchResults["index"][index];
            Navigator.push(
              context,
              new MaterialPageRoute<Null>(
                  builder: (BuildContext context) => WordsListViewRoot(
                    index : searchResults["index"][index]
                  )
              )
            );
          },
        );
      },
    );
  }
}

class InputView extends StatelessWidget{
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        toLeft(Text("単語帳検索")),
        Divider(),
        _WordsSearchWidget()
      ],
    );
  }
}

class _WordsSearchWidget extends StatefulWidget{
  @override
  _WordsSearchWidgetState createState() => new _WordsSearchWidgetState();
}

class _WordsSearchWidgetState extends State<_WordsSearchWidget>{
  toLeft(widget) => Tools.toLeft(widget);
  bool _searchWithTitle = true;
  final TextEditingController searchKeyWord = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            RadioListTile<bool>(
              title: const Text("タグ"),
              groupValue: _searchWithTitle,
              value: false,
              onChanged: (bool value){setState(() {_searchWithTitle = value;});},
            ),
            RadioListTile<bool>(
              title: const Text("タイトル"),
              groupValue: _searchWithTitle,
              value: true,
              onChanged: (bool value){setState(() {_searchWithTitle = value;});},
            )
          ],
        ),
        Row(
          children: [
            TextField(
              controller: searchKeyWord,
              decoration: InputDecoration(
                labelText: "${_searchWithTitle ? "タイトル" : "タグ"}",
                hintText: "検索",
                border: OutlineInputBorder(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                if (searchKeyWord.text.trim() == "") return;
                WordsSearchViewRootState.inputKeyWord = searchKeyWord.text;
                searchKeyWord.text = "";
                WordsSearchViewRootState.searchView = true;
              },
            )
          ]
        )
      ],
    );
  }
}

class SearchResults extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Text("検索結果", style: TextStyle(fontSize: 30),),
              Divider(),
              Expanded(
                child: HitWordsList(),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        )
      ],
    );
  }
}

class HitWordsList extends StatefulWidget{
  @override
  HitWordsListState createState() => HitWordsListState();
}

// 単語の検索結果
class HitWordsListState extends State<HitWordsList>{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WordsSearchViewRootState.search(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
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
}
