import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'types.dart';
class HoldData{
  static List<dynamic> wordsListList;
  static int wordsListIndex;
  static WordsList wordsList;
  static Words word;
  static int wordIndex;
  static final tags = ["word", "mean", "correct", "missCount", "memorized"];
  static void saveWordsList()async{
    var json = jsonEncode(wordsListList);
    _save("json", json);
  }
  static void _save(String key, String json)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, json);
  }
  static void removeWord(){
    wordsList.words.removeAt(wordIndex);
    wordsListList[HoldData.wordsListIndex] = HoldData.wordsList;
    saveWordsList();
  }
  static void makeNewWordsList(String title, String tag, List<String> words){
    wordsListList.add(WordsList(title, tag, []));
    saveWordsList();
  }
  static void loadWordsList(int index){
    wordsList = wordsListList[index];
  }
  static void getWord(int index){
    var cache = [];
    for (String tag in tags){
      cache.add(wordsList.words[index][tag]);
    }
    word =  Words(cache[0], cache[1], cache[2], cache[3], cache[4]);
    wordIndex = index;
  }
}
