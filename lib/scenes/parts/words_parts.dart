import 'package:flutter/material.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/types.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bentsuyo_app/tools/data.dart';
import '../words.dart';

class _WordsListAddState extends State<WordsListAdd>{
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController tagController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        child: Column(
          children: <Widget>[
            toLeft(Text("単語帳の追加", style: TextStyle(fontSize: 30),)),
            toLeft(SizedBox(child:TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "単語帳の名前",
                hintText: "単語帳の名前を入力してください",
              ),
              controller: titleController,
            ),height: 100, width: Tools.getWidth(context) * 0.85,)),
            toLeft(SizedBox(child:TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "タグ(1つ)",
                hintText: "タグを入力",
              ),
              controller: tagController,
            ),height: 100, width: Tools.getWidth(context) * 0.85,)
            ),
            RaisedButton(
              child: Text("追加"),
              shape: UnderlineInputBorder(),
              onPressed: () {
                String title = titleController.text;
                String tag = tagController.text;
                if (title == "" || tag == ""){
                  return;
                }
                HoldData.makeNewWordsList(title, tag, []);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}

class WordsListAdd extends StatefulWidget{
  @override
  _WordsListAddState createState() => new _WordsListAddState();
}

class WordsListList extends StatefulWidget{
  @override
  _WordsListListState createState() => new _WordsListListState();
}

// [{"title":"単語帳", "tag": "たぐ", "words":[{"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":0},]},]

class _WordsListListState extends State<WordsListList>{
  @override
  Widget build(BuildContext context){
    /*
    saveData("json", """
    [{"title":"単語帳", "tag":"たぐ", "words":[{"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":false}]}]
    """);*/
    var a = '''
    [
      {"title":"単語帳",
        "tag": "たぐ",
        "words":[
          {"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":0}
        ]
      }
    ]
    ''';

    var jsonArray = jsonDecode(a);
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
  static Future getData(String key)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var j = pref.getString("json");
    var jsonArray = json.decode(j);
    /*
    var a = [[
      {"title":"単語帳",
        "tag": "たぐ",
        "words":[
          {"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":0},
        ]
      },
    ];*/
    HoldData.wordsListList = jsonArray.map((i) => new WordsList.fromJson(i)).toList();
    return ListView.builder(
        itemCount: HoldData.wordsListList.length,
        itemBuilder: (context, int index){
          return GestureDetector(child:Card(
            child: Column(
              children: <Widget>[
                Row(children:<Widget>[
                  Text(HoldData.wordsListList[index].title,
                    style: TextStyle(fontSize: 30),)]),
                Row(children: <Widget>[
                  Text("タグ", style: TextStyle(fontSize: 20),),
                  Card(child:
                  Text(HoldData.wordsListList[index].tag, style: TextStyle(fontSize: 20),))])
              ],
            ),
          ),
            onTap: (){
              HoldData.loadWordsList(index);
              HoldData.wordsListIndex = index;
              Navigator.push(context, new MaterialPageRoute<Null>(
                  builder: (BuildContext context) => WordsListViewRoot(index:index,)));
            },
          );
        });
  }
}

class WordsListTitle extends StatefulWidget{
  @override
  _WordsListTitleState createState() => new _WordsListTitleState();
}

class _WordsListTitleState extends State<WordsListTitle>{
  toLeft(widget) => Tools.toLeft(widget);
  var word;
  @override
  Widget build(BuildContext context) {
    word = HoldData.wordsListList[HoldData.wordsListIndex].title;
    return toLeft(Text(word,
      style: TextStyle(fontSize: 40),));
  }
}

// ignore: must_be_immutable
class WordsListView extends StatefulWidget{
  WordsList wordsList;
  WordsListView({this.wordsList});
  @override
  _WordsListViewState createState() => new _WordsListViewState();
}

class _WordsListViewState extends State<WordsListView>{
  Widget toLeft(widget) => Tools.toLeft(widget);
  getHeight(context) => Tools.getHeight(context);
  getWidth(context) => Tools.getWidth(context);
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
    /*
    var a = [
      {"title":"単語帳",
        "tag": "たぐ",
        "words":[
          {"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":0},
        ]
      },
    ];*/
    var words = jsonArray.map((i) => new WordsList.fromJson(i)).toList();
    HoldData.wordsList = words[HoldData.wordsListIndex];
    return ListView.builder(itemBuilder: (context, int index){
      if (index == HoldData.wordsList.words.length){
        return GestureDetector(child:toLeft(Text(HoldData.wordsList.words[index].word)), onTap: (){
          HoldData.getWord(index);
          Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) => new DetailViewRoot()));
        },);
      }
      return Column(children: <Widget>[
        GestureDetector(child: toLeft(Text(HoldData.wordsList.words[index]["word"])),
          onTap: (){
            HoldData.getWord(index);
            Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) => new DetailViewRoot()));

          },),
        Divider()
      ]
      );
    },
      itemCount: HoldData.wordsList.words.length,);
  }
}

class ForgetWordsList extends StatefulWidget{
  @override
  _ForgetWordsListState createState() => new _ForgetWordsListState();
}

class _ForgetWordsListState extends State<ForgetWordsList>{
  getWidth(context) => Tools.getWidth(context);
  @override
  Widget build(BuildContext context) {
    HoldData.wordsList = HoldData.wordsListList[HoldData.wordsListIndex];
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
              height: 180,
              width: getWidth(context) * 0.9,
              child: Card(child:ListView.builder(itemBuilder: (context, int index){
                bool initial = true;
                bool flag = true;
                if (initial)for (var i in HoldData.wordsList.words){
                  if (i is Words){
                    if(i.memorized) flag = false;
                  }
                  else if(!i["memorized"]){
                    flag = false;
                  }
                }
                initial = false;
                if (index == 0 && flag){
                  return Text("ないです");
                }else if(!HoldData.wordsList.words[index].memorized){
                  return GestureDetector(child:
                  Text(HoldData.wordsList.words[index].word),
                      onTap: () {
                        HoldData.getWord(index);
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) => new DetailViewRoot()
                        )
                        );
                      }
                  );
                }else{
                  return Container();
                }
              },itemCount: HoldData.wordsList.words.length,),
              )
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class WordsDetailTitle extends StatefulWidget{
  @override
  _WordsDetailTitleState createState() => new _WordsDetailTitleState();
}

class _WordsDetailTitleState extends State<WordsDetailTitle>{
  @override
  Widget build(BuildContext context) {
    return Text(HoldData.word.word, style: TextStyle(fontSize: 30),);
  }
}

// ignore: must_be_immutable
class WordsDetailMean extends StatefulWidget{
  @override
  _WordsDetailMeanState createState() => new _WordsDetailMeanState();
}

class _WordsDetailMeanState extends State<WordsDetailMean>{
  getWidth(context) => Tools.getWidth(context);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
          child:Flex(children: <Widget>[
            Flexible(child:
            Text(HoldData.word.mean, style: TextStyle(fontSize: 25),)),],
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
          )),
      width: getWidth(context) * 0.9,
      height: 200,
    );
  }
}

// ignore: must_be_immutable
class WordsDetailDetail extends StatefulWidget{
  @override
  _WordsDetailDetailState createState() => new _WordsDetailDetailState();
}

class _WordsDetailDetailState extends State<WordsDetailDetail>{
  var correctPer;
  @override
  Widget build(BuildContext context) {
    Words word = HoldData.word;
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
  _WordsAddState createState() => new _WordsAddState();
}

class _WordsAddState extends State<WordsAdd>{
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController wordController = new TextEditingController();
  final TextEditingController meanController = new TextEditingController();
  final TextEditingController tagController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  HoldData.wordsList.words.add(Words(word, mean, 0, 0, false));
                  HoldData.wordsListList[HoldData.wordsListIndex] = HoldData.wordsList;
                  HoldData.saveWordsList();
                  Navigator.pop(context);
                },
              ),
            ],
          ),padding: EdgeInsets.all(10.0),
          ),)
    );
  }
}