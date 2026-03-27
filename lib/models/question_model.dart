class Question {
  final int id;
  final String question;
  final List<String> answers;
  final int correctIndex;

  Question({
    required this.id,
    required this.question,
    required this.answers,
    required this.correctIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      question: json['text'] as String,
      answers: List<String>.from(json['answers'] as List<dynamic>),
      correctIndex: json['correct_index'] as int,
    );
  }
}
