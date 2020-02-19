import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'types.dart';

class HoldData {
  static List<dynamic> wordsListList;
  static int wordsListIndex;
  static WordsList wordsList;
  static Words word;
  static int wordIndex;
  static int formulaIndex;
  static List<dynamic> formulasList = [];
  static Formula formula;
  static final tags = ["word", "mean", "correct", "missCount", "memorized"];
  static void saveWordsListToLocal() async {
    var json = jsonEncode(wordsListList);
    _saveToLocal("json", json);
  }

  static void saveFormulasListToLocal() async {
    var json = jsonEncode(formulasList);
    _saveToLocal("formulas", json);
  }

  static void _saveToLocal(String key, String json) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, json);
  }

  static void removeWord() {
    wordsList.words.removeAt(wordIndex);
    wordsListList[HoldData.wordsListIndex] = HoldData.wordsList;
    saveWordsListToLocal();
  }

  static void addNewFormula(String formula, String name, String subject) async {
    if (formulasList.length == 0) formulasList = [new Formula(formula, name, subject)];
    else formulasList.add(new Formula(formula, name, subject));
    saveFormulasListToLocal();
  }

  static void makeNewWordsList(String title, String tag, List<String> words) {
    try {
      wordsListList.add(WordsList(title: title, tag: tag, words: []));
    }catch(any){
      wordsListList = [WordsList(title: title,tag: tag, words: [])];
    }
    saveWordsListToLocal();
  }

  static void loadWordsList(int index) {
    wordsList = wordsListList[index];
  }

  static void getWord(int index) {
    var value = wordsList.words[index];
    if (value is Words)
      word = new Words(
          word:      value.word,
          mean:      value.mean,
          missCount: value.missCount,
          correct:   value.correct,
          memorized: value.memorized
      );
    else
      word = new Words(
          word:      value["word"],
          mean:      value["mean"],
          missCount: value["missCount"],
          correct:   value["correct"],
          memorized: value["memorized"]
      );
    wordIndex = index;
  }

  static void _saveWordsListToListList() {
    wordsListList[wordsListIndex] = wordsList;
    saveWordsListToLocal();
  }

  static void loadFormula(int index){
    formula = formulasList[index];
  }

  static void deleteFormula(){
    int index = 0;
    for (Formula f in formulasList){
      if (f.formula == formula.formula) break;
      index++;
    }
    formulasList.removeAt(index);
    formula = null;
    saveFormulasListToLocal();
  }

  static void afterAnswer(Words words, bool result) {
    int index = searchWordFromWordList(words);
    print("correct$index");
    if (result) words.correct += 1;
    else words.missCount += 1;
    if (words.correct > words.missCount) words.memorized = true;
    else words.memorized = false;
    wordsList.words[index] = words;
    _saveWordsListToListList();
  }

  static void deleteWordsList(){
    wordsListList.removeAt(wordsListIndex);
    wordsList = null;
    saveWordsListToLocal();
  }

  static int searchWordFromWordList(Words word){
    int index = 0;
    for (var w in wordsList.words) {
      if (w is Words) {
        if (w.word == word.word) break;
      } else {
        if (w["word"] == word.word) break;
      }
      index++;
    }
    return index;
  }

  static Future loadData(String key) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var j = pref.getString(key);
    if (key == "formulas" && j == null){
      HoldData.formulasList =[];
      return;
    }
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
    if (key == "formulas") HoldData.formulasList = jsonArray.map((i) => new Formula.fromJson(i)).toList();
    else if (key == "wordsListList")HoldData.wordsListList =
        jsonArray.map((i) => new WordsList.fromJson(i)).toList();
  }

  static int getWordsListIndex(WordsList wordsList){
    int index = 0;
    for (WordsList w in HoldData.wordsListList){
      if (w == wordsList) break;
      index++;
    }
    return index;
  }
}
