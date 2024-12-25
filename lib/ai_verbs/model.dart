class GermanDataModel {
  final String germanData;
  final DataForms dataForms;
  final ExampleSentences exampleSentences;

  GermanDataModel({
    required this.germanData,
    required this.dataForms,
    required this.exampleSentences,
  });

  factory GermanDataModel.fromJson(Map<String, dynamic> json) {
    return GermanDataModel(
      germanData: json['german_data'],
      dataForms: DataForms.fromJson(json['data_forms']),
      exampleSentences: ExampleSentences.fromJson(json['example_sentences']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'german_data': germanData,
      'data_forms': dataForms.toJson(),
      'example_sentences': exampleSentences.toJson(),
    };
  }
}

class DataForms {
  final Map<String, String> present;
  final Map<String, String> presentContinuous;
  final Map<String, String> past;
  final String pastParticiple;

  DataForms({
    required this.present,
    required this.presentContinuous,
    required this.past,
    required this.pastParticiple,
  });

  factory DataForms.fromJson(Map<String, dynamic> json) {
    return DataForms(
      present: Map<String, String>.from(json['present']),
      presentContinuous: Map<String, String>.from(json['present_continuous']),
      past: Map<String, String>.from(json['past']),
      pastParticiple: json['past_participle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'present': present,
      'present_continuous': presentContinuous,
      'past': past,
      'past_participle': pastParticiple,
    };
  }
}

class ExampleSentences {
  final String present;
  final String presentContinuous;
  final String past;
  final String pastParticiple;

  ExampleSentences({
    required this.present,
    required this.presentContinuous,
    required this.past,
    required this.pastParticiple,
  });

  factory ExampleSentences.fromJson(Map<String, dynamic> json) {
    return ExampleSentences(
      present: json['present'],
      presentContinuous: json['present_continuous'],
      past: json['past'],
      pastParticiple: json['past_participle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'present': present,
      'present_continuous': presentContinuous,
      'past': past,
      'past_participle': pastParticiple,
    };
  }
}
