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
  static List<dynamic> formulasList;
  static Formula formula;
  static final tags = ["word", "mean", "correct", "missCount", "memorized"];
  static void saveWordsList() async {
    var json = jsonEncode(wordsListList);
    _save("json", json);
  }

  static void saveFormulasList() async {
    var json = jsonEncode(formulasList);
    _save("formulas", json);
  }

  static void _save(String key, String json) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, json);
  }

  static void removeWord() {
    wordsList.words.removeAt(wordIndex);
    wordsListList[HoldData.wordsListIndex] = HoldData.wordsList;
    saveWordsList();
  }

  static void addNewFormula(String formula, String name, String subject) async {
    Formula newFormula = new Formula(formula, name, subject);
    formulasList.add(newFormula);
    saveFormulasList();
  }

  static void makeNewWordsList(String title, String tag, List<String> words) {
    wordsListList.add(WordsList(title, tag, []));
    saveWordsList();
  }

  static void loadWordsList(int index) {
    wordsList = wordsListList[index];
  }

  static void getWord(int index) {
    var value = wordsList.words[index];
    if (value is Words)
      word = new Words(value.word, value.mean, value.missCount, value.correct,
          value.memorized);
    else
      word = new Words(value["word"], value["mean"], value["missCount"],
          value["correct"], value["memorized"]);
    wordIndex = index;
  }

  static void _saveWordsListToListList() {
    wordsListList[wordsListIndex] = wordsList;
    saveWordsList();
  }

  static void loadFormula(int index){
    formula = formulasList[index];
  }

  static void deleteFormula(){
    formulasList.remove(formula);
    formula = null;
    saveFormulasList();
  }

  static void afterAnswer(Words words, bool result) {
    int index = 0;
    for (var baruxu in wordsList.words) {
      if (baruxu is Words) {
        if (baruxu.word == words.word) break;
      } else {
        if (baruxu["word"] == words.word) break;
      }
      index++;
    }
    print("correct$index");
    if (result)
      words.correct += 1;
    else
      words.missCount += 1;
    if (words.correct > words.missCount)
      words.memorized = true;
    else
      words.memorized = false;
    print(wordsList.words[0]);
    wordsList.words[index] = words;
    _saveWordsListToListList();
  }
}
