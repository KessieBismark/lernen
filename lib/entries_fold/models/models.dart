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

class GrammerModel {
  final String id;
  final String du;
  final String eng;
  final String? nom;
  final String? caseData;

  GrammerModel(
      {required this.eng,
      required this.id,
      required this.du,
      this.nom,
      this.caseData});

  factory GrammerModel.fromJson(Map<String, dynamic> map) {
    return GrammerModel(
        id: map['id'],
        du: map['de'],
        eng: map['en'],
        nom: map['nominative'] ?? '',
        caseData: map['case'] ?? '');
  }
}

class SentenceModel {
  final String id;
  final String? du;
  final String? eng;
  final String? word;
  final String? gcase;
  final String? stype;
  final VocabularyModel? vocab;

  SentenceModel(
      {required this.id,
      this.vocab,
      this.du,
      this.eng,
      this.word,
      this.gcase,
      this.stype});

  factory SentenceModel.fromJson(Map<String, dynamic> map) {
    return SentenceModel(
        id: map['id'],
        du: map['deutsch'] ?? '',
        eng: map['english'] ?? '',
        word: map['word'] ?? '',
        gcase: map['gcase'] ?? '',
        vocab: map['expand'] != null && map['expand']['voc_fk'] != null
            ? VocabularyModel.fromJson(
                map['expand']['voc_fk']) // Parsing VocabularyModel
            : null,
        stype: map['s_type'] ?? '');
  }
}

class ConModel {
  final String id;
  final String? du;
  final String? eng;
  final String? word;
  final String? gcase;
  final String? stype;

  ConModel(
      {required this.id, this.du, this.eng, this.word, this.gcase, this.stype});

  factory ConModel.fromJson(Map<String, dynamic> map) {
    return ConModel(
        id: map['id'],
        du: map['deutsch'] ?? '',
        eng: map['english'] ?? '',
        word: map['word'] ?? '',
        gcase: map['gcase'] ?? '',
        // vocab: map['expand'] != null && map['expand']['voc_fk'] != null
        //     ? VocabularyModel.fromJson(
        //         map['expand']['voc_fk']) // Parsing VocabularyModel
        //     : null,
        stype: map['s_type'] ?? '');
  }
}

class PossModel {
  final String id;
  final String? tense;

  final String? word;
  final VocabularyModel? vocabs;

  PossModel({required this.id, this.tense, this.word, this.vocabs});

  factory PossModel.frmJson(Map<String, dynamic> map) {
    return PossModel(
      id: map['id'],
      tense: map['tense'] ?? '',
      word: map['word'] ?? '',
      vocabs: map['expand'] != null && map['expand']['voc_fk'] != null
          ? VocabularyModel.fromJson(
              map['expand']['voc_fk']) // Parsing VocabularyModel
          : null,
    );
  }
}

class VerbModel {
  final String id;
  final String? word;
  final String? tense;

  // final VocabularyModel? vocabs;

  VerbModel({
    required this.id,
    this.word,
    this.tense,
  });

  factory VerbModel.frmJson(Map<String, dynamic> map) {
    return VerbModel(
      id: map['id'], tense: map['tense'] ?? '',

      word: map['word'] ?? '',
      // vocabs: map['expand'] != null && map['expand']['voc_fk'] != null
      //     ? VocabularyModel.fromJson(
      //         map['expand']['voc_fk']) // Parsing VocabularyModel
      //     : null,
    );
  }
}
