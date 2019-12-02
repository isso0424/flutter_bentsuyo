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