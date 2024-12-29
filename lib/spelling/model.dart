class VocabularyModel {
  final String id;
  final String? du;
  final String? fe;
  final String? eng;
  final String? past;

  final bool? study;

  VocabularyModel(
      {required this.id,
      this.du,
      this.fe,
      this.past,
      this.eng,
      this.study = false});
  factory VocabularyModel.fromJson(Map<String, dynamic> map) {
    return VocabularyModel(
        id: map['id'],
        du: map['du'] ?? '',
        fe: map['feminie'] ?? '',
        eng: map['en'] ?? '',
        past: map['past'] ?? '',
        study: map['studied']);
  }
}
