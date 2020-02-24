import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/types.dart';
import 'package:bentsuyo_app/tools/without_static/data.dart';

import 'words_add.dart';
import 'detail.dart';

// ignore: must_be_immutable
class WordsListViewRoot extends StatelessWidget {
  WordsList wordsList;
  final int wordsListIndex;
  WordsListViewRoot({this.wordsList, this.wordsListIndex});

  toLeft(widget) => Tools.toLeft(widget);
  getWidth(context) => Tools.getWidth(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: Tools.drawer(context),
      body: Column(
        children: <Widget>[
          toLeft(
              Text(
                  wordsList.title,
                  style: TextStyle(fontSize: 40),
              )
          ),
          Divider(),
          toLeft(
            Text(
              " 単語一覧",
              style: TextStyle(fontSize: 30),
            )
          ),

          // 単語一覧
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: Card(
                    child: WordsListView(wordsListIndex: wordsListIndex,),
                  ),
                  height: 180,
                  width: getWidth(context) * 0.9,
                )
              ],
            ),
          ),
          /*
          TestButton(),
          */
          toLeft(
            Text(
              " まだ覚えていない単語",
              style: TextStyle(fontSize: 30),
            )
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: Card(
                    child: ForgetWordsList(
                      wordsListIndex: wordsListIndex,
                    ),
                  ),
                  height: 180,
                  width: getWidth(context) * 0.9,
                )
              ],
            ),
          ),
          /*
          TestButtonForgotWords()

           */
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) =>
                new WordAddViewRoot(
                  wordsListIndex: wordsListIndex,
                )
              )
          );
        },
      ),
    );
  }

  // 専用AppBar
  Widget _appBar(BuildContext context){
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: (){
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
                        WordsListData.deleteWordsList(wordsListIndex);
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                );
              }
            ).then<void>((y){
              if (y == null) return;
              if (y) Navigator.pop(context);
            });
          }
        )
      ],
    );
  }
}

class WordsListView extends StatefulWidget{
  WordsListView({this.wordsListIndex});
  final int wordsListIndex;

  @override
  _WordsListViewState createState() =>
      _WordsListViewState(wordsListIndex: wordsListIndex);
}

class _WordsListViewState extends State<WordsListView> {
  _WordsListViewState({this.wordsListIndex});
  final int wordsListIndex;
  WordsList wordsList;

  toLeft(widget) => Tools.toLeft(widget);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadWordsList(),
      builder: (
          BuildContext context,
          AsyncSnapshot snapshot
      ){
        if (snapshot.hasData){
          return snapshot.data;
        } else if (snapshot.hasError){
          return Text("Error Occuled!!!\nDetail is this.\n${snapshot.error}");
        }else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future loadWordsList() async{
    wordsList = (await WordsListData.loadWordsListList())[wordsListIndex];
    return ListView.builder(
      itemBuilder: (
        BuildContext context,
        int index
      ){
        if (index == wordsList.words.length){
          return GestureDetector(
            child: toLeft(
              Text(
                  wordsList.words[index].word
              )
            ),
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new WordDetailRoot(
                    wordsListIndex: wordsListIndex,
                    wordIndex:      index,
                    word:           wordsList.words[index],
                  )
                )
              );
            },
          );
        }
        return Column(
          children: <Widget>[
            GestureDetector(
              child: toLeft(
                Text(wordsList.words[index].word)
              ),
              onTap: (){
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new WordDetailRoot(
                      wordsListIndex: wordsListIndex,
                      wordIndex:      index,
                      word:           wordsList.words[index],
                    )
                  )
                );
              },
            ),
            Divider()
          ],
        );
      },
      itemCount: wordsList.words.length,
    );
  }
}

class ForgetWordsList extends StatefulWidget{
  ForgetWordsList({this.wordsListIndex});
  final int wordsListIndex;
  @override
  _ForgetWordsListState createState() =>
      _ForgetWordsListState(wordsListIndex:  wordsListIndex);
}

class _ForgetWordsListState extends State<ForgetWordsList>{
  _ForgetWordsListState({this.wordsListIndex});
  final int wordsListIndex;

  WordsList wordsList;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadForgetWords(),
      builder: (
          BuildContext context,
          AsyncSnapshot snapshot
      ){
        if (snapshot.hasData){
          return snapshot.data;
        } else if (snapshot.hasError){
          return Text(
              "Error occured!!!\nDetail is this.\n${snapshot.hasError}"
          );
        } else{
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future _loadForgetWords()async{
    wordsList = (await WordsListData.loadWordsListList())[wordsListIndex];
    bool notFound = true;
    for (Words w in wordsList.words){
      if (!w.memorized) {
        notFound = false;
        break;
      }
    }
    if (notFound) return Text("ないです");
    bool first = true;
    return ListView.builder(
      itemCount: wordsList.words.length,
      itemBuilder: (
          BuildContext context,
          int index
      ){
        if (wordsList.words[index].memorized) return Container();
        else if (first){
          first = false;
          return GestureDetector(
            child: Text(
              wordsList.words[index].word
            ),
            onTap: (){
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new WordDetailRoot(
                      wordsListIndex: wordsListIndex,
                      wordIndex:      index,
                      word:           wordsList.words[index],
                    )
                )
              );
            },
          );
        } else{
          return Column(
            children: <Widget>[
              Divider(),
              GestureDetector(
                child: Text(
                  wordsList.words[index].word
                ),
                onTap: (){
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) =>
                        new WordDetailRoot(
                          wordsListIndex: wordsListIndex,
                          wordIndex:      index,
                          word:           wordsList.words[index],
                        )
                    )
                  );
                },
              )
            ],
          );
        }
      },
    );
  }
}
