import 'dart:convert';

class QuizModel {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explaination;
  final String english;

  QuizModel(
      {required this.question,
      required this.options,
      required this.english,
      required this.correctAnswer,
      required this.explaination});

// Update QuizModel.fromJson to be more resilient
factory QuizModel.fromJson(Map<String, dynamic> map) {
  // Ensure all fields have defaults
  return QuizModel(
    question: map['question']?.toString() ?? '',
    english: map['english_translation']?.toString() ?? '',
    options: _parseOptions(map['options']),
    correctAnswer: map['correct_answer']?.toString() ?? '',
    explaination: map['english_explanation']?.toString() ?? '',
  );
}

}
List<String> _parseOptions(dynamic options) {
  if (options == null) return [];
  
  if (options is List) {
    return options.map((e) => e.toString()).toList();
  }
  
  if (options is String) {
    try {
      // Try to parse as JSON array string
      final parsed = jsonDecode(options);
      if (parsed is List) {
        return parsed.map((e) => e.toString()).toList();
      }
    } catch (e) {
      // If not JSON, split by commas
      return options.split(',').map((e) => e.trim()).toList();
    }
  }
  
  return [];
}
