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

  factory QuizModel.fromJson(Map<String, dynamic> map) {
    return QuizModel(
        question: map['question'],
        english: map['english_translation'],
        options: List<String>.from(map['options']),
        correctAnswer: map['correct_answer'],
        explaination: map['english_explanation']);
  }
}
