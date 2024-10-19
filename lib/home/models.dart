
class WordData {
  final String translation;
  final List<Sentence> sentences;

  WordData({required this.translation, required this.sentences});

  factory WordData.fromJson(Map<String, dynamic> json) {
    var list = json['sentences'] as List;
    List<Sentence> sentencesList =
        list.map((i) => Sentence.fromJson(i)).toList();

    return WordData(
      translation: json['translation'],
      sentences: sentencesList,
    );
  }
}

class Sentence {
  final String sentenceDe;
  final String sentenceEn;

  Sentence({required this.sentenceDe, required this.sentenceEn});

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      sentenceDe: json['sentence_de'],
      sentenceEn: json['sentence_en'],
    );
  }
}
