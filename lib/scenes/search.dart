import 'package:bentsuyo_app/scenes/words.dart';
import 'package:bentsuyo_app/tools/types.dart';
import 'package:flutter/material.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'dart:core';
import 'package:bentsuyo_app/tools/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
    var searchResults = [];
    int index = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var j = pref.getString("wordsListList");
    var jsonArray = json.decode(j);
    var wordsListList =
        jsonArray.map((i) => new WordsList.fromJson(i)).toList();
    if (searchWithTag) {
      for (var wordsL in wordsListList) {
        if (wordsL is WordsList) {
          if (wordsL.tag == inputKeyWord) searchResults.add([wordsL, index]);
        }else{
          if (wordsL["tag"] == inputKeyWord) searchResults.add(
              [
                WordsList(
                    title: wordsL["title"],
                    tag:   wordsL["tag"],
                    words: wordsL["words"]
                ),
                index
              ]
          );
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
            HoldData.loadData(searchResults[index][1]);
            HoldData.wordsListIndex = searchResults[index][1];
            Navigator.push(
              context,
              new MaterialPageRoute<Null>(
                  builder: (BuildContext context) => WordsListViewRoot(
                    index : searchResults[index][1]
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
