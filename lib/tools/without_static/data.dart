import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../types.dart';

class WordsListData {
  static bool saving = false;
  static Future<List<WordsList>> loadWordsListList() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var j = pref.getString("wordsListList");
    print("j: $j");
    // もし単語帳が存在しなかった場合
    if (j == null){
      List<WordsList> l = [];
      saveToWordsList(l);
      return l;
    }

    // 帰ってきた文字列からList<dynamic>を生成
    var jsonArray = json.decode(j);
    var m = jsonArray.map((i) => new RawWordsList.fromJson(i)).toList();
    // 中身をWordsListにキャストする
    List<WordsList> castedList = [];
    for (var v in m){
      List<Words> words = [];
      if (! (v is RawWordsList)){
        for (var w in v["words"]){
          words.add(
            Words(
              word:      w["word"],
              mean:      w["mean"],
              correct:   w["correct"],
              missCount: w["missCount"],
              memorized: w["memorized"]
            )
          );
        }
        castedList.add(
            WordsList(
                tag:   v["tag"],
                title: v["title"],
                words: words
            )
        );
      }
      else{
        for (var w in v.words){
          words.add(
              Words(
                  word:      w["word"],
                  mean:      w["mean"],
                  correct:   w["correct"],
                  missCount: w["missCount"],
                  memorized: w["memorized"]
              )
          );
        }
        castedList.add(
          WordsList(
            tag:   v.tag,
            title: v.title,
            words: words
          )
        );
      }
    }
    return castedList;
  }

  static void deleteWordsList(int index) async{
    // 単語帳リストをロード
    List<WordsList> wordsListList = await WordsListData.loadWordsListList();

    // 該当indexの単語帳を削除してそれをローカルに保存
    SharedPreferences pref = await SharedPreferences.getInstance();
    wordsListList.removeAt(index);
    String json = jsonEncode(wordsListList);
    pref.setString("wordsListList", json);
  }

  // 単語帳リストの保存
  static void saveToWordsList(List<WordsList> wordsList) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var json = jsonEncode(wordsList);
    print(json);
    pref.setString("wordsListList", json);
  }

  // 単語の追加
  static Future addToWordsList(int wordsListIndex, Words word) async{
    print("un");
    List<WordsList> wordsListList = await loadWordsListList();
    wordsListList[wordsListIndex].words.add(word);
    saveToWordsList(wordsListList);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String a = pref.getString("wordsListList");
    print(a);
  }

  static Future refreshWordsList(int wordsListIndex, WordsList wordsList) async{
    List<WordsList> wordsListList = await loadWordsListList();
    wordsListList[wordsListIndex] = wordsList;
    saveToWordsList(wordsListList);
  }

  // 単語帳の追加
  static void addNewWordsList(WordsList wordsList) async{
    List<WordsList> root = await loadWordsListList();
    root.add(wordsList);
    saveToWordsList(root);
  }

  static void removeWord(int wordsListIndex, int wordIndex) async{
    List<WordsList> wordsList = await loadWordsListList();
    wordsList[wordsListIndex].words.removeAt(wordIndex);
    saveToWordsList(wordsList);
  }
}