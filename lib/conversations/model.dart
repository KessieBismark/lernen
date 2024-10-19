class WordModel {
  final String id;
  final String word;
  final String trans;

  WordModel({required this.id, required this.word, required this.trans});

  factory WordModel.fromJson(Map<String, dynamic> map) {
    return WordModel(
        id: map['id'], word: map['word'], trans: map['translation']);
  }
}
