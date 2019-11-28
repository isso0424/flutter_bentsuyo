import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'tool.dart';

class WordsListRoot extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
    );
  }
}

class WordsListList extends StatefulWidget{
  @override
  WordsListListState createState() => new WordsListListState();
}
// [{"title":"単語帳", "tag": "たぐ", "words":[{"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":0},]},]
class Words{
  final String word;
  final String mean;
  final int missCount;
  final int correct;
  final bool memorized;
  Words(this.word, this.mean, this.missCount, this.correct, this.memorized);
  Words.fromJson(Map<String, dynamic> json)
        : word = json['word'],
          mean = json['mean'],
          missCount = json['missCount'],
          correct = json['correct'],
          memorized = json['memorized'];
  Map<String, dynamic> toJson() =>
      {
        'word':word,
        'mean':mean,
        'missCount':missCount,
        'correct':correct,
        'memorized':memorized
      };
}

class WordsList{
  final String title;
  final String tag;
  final List<dynamic> words;
  WordsList(this.title, this.tag, this.words);
  WordsList.fromJson(Map<String, dynamic> json)
        :title = json['title'],
        tag= json['tag'],
        words = json['words'];
  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'tag':tag,
        'words':words
      };
}

class WordsListListState extends State<WordsListList>{
  static List<dynamic> wordsList;
  static int wordsListIndex;
  @override
  Widget build(BuildContext context){
    /*
    saveData("json", """
    [{"title":"単語帳", "tag":"たぐ", "words":[{"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":false}]}]
    """);*/
    return
      FutureBuilder(
        future: getData("wordsListList"),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return snapshot.data;
          }else if(snapshot.hasError){
            return Text("Error!");
          }
          else{
            return Container(child: CircularProgressIndicator(),);
          }
          },

    );
  }
  static void saveData(String key, String json)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, json);
  }
  static Future getData(String key)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var j = pref.getString("json");
    var jsonArray = json.decode(j);
    var a = [
      {"title":"単語帳",
        "tag": "たぐ",
        "words":[
          {"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":0},
        ]
      },
    ];
    wordsList = jsonArray.map((i) => new WordsList.fromJson(i)).toList();
    return ListView.builder(
    itemCount: wordsList.length,
    itemBuilder: (context, int index){
      return GestureDetector(child:Card(
          child: Column(
            children: <Widget>[
              Row(children:<Widget>[
              Text(wordsList[index].title,
                style: TextStyle(fontSize: 30),)]),
              Row(children: <Widget>[
                Text("タグ", style: TextStyle(fontSize: 20),),
              Card(child:
              Text(wordsList[index].tag, style: TextStyle(fontSize: 20),))])
            ],
          ),
        ),
        onTap: (){
          wordsListIndex = index;
          WordsListViewState.wordsList = wordsList[index];
          Navigator.push(context, new MaterialPageRoute<Null>(
              builder: (BuildContext context) => WordsListViewRoot(index:index,)));
        },
      );
    });
  }
}

class WordsListViewRoot extends StatelessWidget{
  WordsListViewRoot({this.index});
  int index;
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          WordsListTitle(),
          Divider(),
          toLeft(Text("　単語一覧",
            style: TextStyle(fontSize: 30),)),
          WordsListView(),
          toLeft(Text("　まだわかってない単語", style: TextStyle(fontSize: 30),)),
          ForgetWordsList()
        ],
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: (){
            Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) => new WordsAdd()
            ));
          },)
    );
  }
}

class WordsListTitle extends StatefulWidget{
  @override
  WordsListTitleState createState() => new WordsListTitleState();
}

class WordsListTitleState extends State<WordsListTitle>{
  toLeft(widget) => Tools.toLeft(widget);
  var word;
  @override
  Widget build(BuildContext context) {
    word = WordsListListState.wordsList[WordsListListState.wordsListIndex].title;
    return toLeft(Text(word,
      style: TextStyle(fontSize: 40),));
  }
}

// ignore: must_be_immutable
class WordsListView extends StatefulWidget{
  WordsList wordsList;
  WordsListView({this.wordsList});
  @override
  WordsListViewState createState() => new WordsListViewState();
}

class WordsListViewState extends State<WordsListView>{
  Widget toLeft(widget) => Tools.toLeft(widget);
  getHeight(context) => Tools.getHeight(context);
  getWidth(context) => Tools.getWidth(context);
  static WordsList wordsList;
  @override
  Widget build(BuildContext context) {

    return Container(
            child: Column(children: <Widget>[
              SizedBox(child:Card(child: FutureBuilder(
                future: loadWordsList(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return snapshot.data;
                  }else if(snapshot.hasError){
                    return Text("Error!");
                  }
                  else{
                    return Container(child: CircularProgressIndicator(),);
                  }
                },
              ),
                  /*
              */),
              height: 180,
                  width: getWidth(context) * 0.9,)]),

          );
  }

  Future loadWordsList()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var j = pref.getString("json");
    var jsonArray = json.decode(j);
    var a = [
      {"title":"単語帳",
        "tag": "たぐ",
        "words":[
          {"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":0},
        ]
      },
    ];
    var words = jsonArray.map((i) => new WordsList.fromJson(i)).toList();
    (words);
    wordsList = words[WordsListListState.wordsListIndex];
    return ListView.builder(itemBuilder: (context, int index){
      if (index == wordsList.words.length){
        return GestureDetector(child:toLeft(Text(wordsList.words[index]["word"])), onTap: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) => new DetailViewRoot(word: Words(wordsList.words[index]["word"],wordsList.words[index]["mean"], wordsList.words[index]["correct"], wordsList.words[index]["missCount"], wordsList.words[index]["memorized"]), index: index,)));
        },);
      }
      return Column(children: <Widget>[
        GestureDetector(child: toLeft(Text(wordsList.words[index]["word"])),
          onTap: (){
            Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) => new DetailViewRoot(word: Words(wordsList.words[index]["word"],wordsList.words[index]["mean"], wordsList.words[index]["correct"], wordsList.words[index]["missCount"], wordsList.words[index]["memorized"]), index: index,)));

          },),
        Divider()
      ]
      );
    },
      itemCount: wordsList.words.length,);
  }
}

class ForgetWordsList extends StatefulWidget{
  @override
  ForgetWordsListState createState() => new ForgetWordsListState();
}

class ForgetWordsListState extends State<ForgetWordsList>{
  getWidth(context) => Tools.getWidth(context);
  static WordsList wordsList;
  @override
  Widget build(BuildContext context) {
    wordsList = WordsListListState.wordsList[WordsListListState.wordsListIndex];
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
              height: 180,
              width: getWidth(context) * 0.9,
              child: Card(child:ListView.builder(itemBuilder: (context, int index){
                bool initial = true;
                bool flag = true;
                if (initial)for (var i in wordsList.words){
                  if(!i["memorized"]){
                    flag = false;
                  }
                }
                initial = false;
                if (index == 0 && flag){
                  return Text("ないです");
                }else if(!wordsList.words[index]["memorized"]){
                  return GestureDetector(child:
                  Text(wordsList.words[index]["word"]),
                      onTap: () {
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) => new DetailViewRoot(
                          word: Words(wordsList.words[index]["word"],
                              wordsList.words[index]["mean"],
                              wordsList.words[index]["correct"],
                              wordsList.words[index]["missCount"],
                              wordsList.words[index]["memorized"])
                          ,index: index,
                        )
                    )
                    );
                  }
                  );
                }else{
                  return Container();
                }
          },itemCount: wordsList.words.length,),
          )
          )
        ],
      ),
    );
  }
}

class DetailViewRoot extends StatelessWidget{
  toLeft(widget) => Tools.toLeft(widget);
  Words word;
  int index;
  DetailViewRoot({this.word, this.index});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    (word.word);
    return Scaffold(
      appBar: AppBar(),
      body: Scaffold(
        body: Padding(
          child: Column(
            children: <Widget>[
              toLeft(WordsDetailTitle(word: word)),
              Divider(),
              toLeft(Text("意味")),
              WordsDetailMean(word: word,),
              toLeft(Text("詳細")),
              WordsDetailDetail(word: word,),
              RaisedButton(
                child: Text("単語の削除"),
                color: Colors.red,
                shape: StadiumBorder(),
                onPressed: () {
                  WordsListViewState.wordsList.words.removeAt(index);
                  WordsListListState.wordsList[WordsListListState.wordsListIndex] = WordsListViewState.wordsList;
                  var json = jsonEncode(WordsListListState.wordsList);
                  WordsListListState.saveData("json", json);
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

class WordsDetailTitle extends StatefulWidget{
  Words word;
  WordsDetailTitle({this.word});
  @override
  WordsDetailTitleState createState() => new WordsDetailTitleState(word: word);
}

class WordsDetailTitleState extends State<WordsDetailTitle>{
  Words word;
  WordsDetailTitleState({this.word});
  @override
  Widget build(BuildContext context) {
    (word.word);
    return Text(word.word, style: TextStyle(fontSize: 30),);
  }
}

class WordsDetailMean extends StatefulWidget{
  Words word;
  WordsDetailMean({this.word});
  @override
  WordsDetailMeanState createState() => new WordsDetailMeanState(word: word);
}

class WordsDetailMeanState extends State<WordsDetailMean>{
  getWidth(context) => Tools.getWidth(context);
  Words word;
  WordsDetailMeanState({this.word});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
          child:Flex(children: <Widget>[
            Flexible(child:
            Text(word.mean, style: TextStyle(fontSize: 25),)),],
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
          )),
      width: getWidth(context) * 0.9,
      height: 200,
    );
  }
}

class WordsDetailDetail extends StatefulWidget{
  Words word;
  WordsDetailDetail({this.word});
  @override
  WordsDetailDetailState createState() => new WordsDetailDetailState(word: word);
}

class WordsDetailDetailState extends State<WordsDetailDetail>{
  Words word;
  WordsDetailDetailState({this.word});
  var correctPer;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (word.missCount+ word.correct == 0){
      correctPer = 0;
    }else{
      correctPer = (word.correct / (word.missCount + word.correct)) * 100;
    }
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          child:Card(
              child: Column(
                children: <Widget>[
                  Text("正解数: ${word.correct }", style: TextStyle(fontSize: 20),),
                  Divider(),
                  Text("誤答数: ${word.missCount}", style: TextStyle(fontSize: 20)),
                  Divider(),
                  Text("正答率: $correctPer %", style: TextStyle(fontSize: 20))
                ],
              )
          ),
        )
    );
  }
}

class WordsAdd extends StatefulWidget{
  @override
  WordsAddState createState() => new WordsAddState();
}

class WordsAddState extends State<WordsAdd>{
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController wordController = new TextEditingController();
  final TextEditingController meanController = new TextEditingController();
  final TextEditingController tagController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
        body: Scaffold(
          body: Padding(child: Column(
            children: <Widget>[
              toLeft(Text("単語の追加",style: TextStyle(fontSize: 20),)),
              toLeft(SizedBox(child:TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "追加する単語",
                  hintText: "追加する単語を入力してください",
                ),
                controller: wordController,
              ),height: 100, width: Tools.getWidth(context) * 0.9,)),
              toLeft(SizedBox(child:TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "単語の意味",
                  hintText: "追加する単語の意味を入力してください"
                ),
                controller: meanController,
              ),height: 100,
                  width: Tools.getWidth(context) * 0.9,),),
              RaisedButton(
                child: Text("追加"),
                shape: UnderlineInputBorder(),
                onPressed: () {
                  String word = wordController.text;
                  String mean = meanController.text;
                  if (word == "" || mean == ""){
                    return;
                  }
                  WordsListViewState.wordsList.words.add(Words(word, mean, 0, 0, false));
                  WordsListListState.wordsList[WordsListListState.wordsListIndex] = WordsListViewState.wordsList;
                  var json = jsonEncode(WordsListListState.wordsList);
                  WordsListListState.saveData("json", json);
                  Navigator.pop(context);
                },
              ),
            ],
          ),padding: EdgeInsets.all(10.0),
        ),)
    );
  }
}