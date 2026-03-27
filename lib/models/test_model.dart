class Test {
  final int id;
  final String title;
  final int questionsCount;

  Test({required this.id, required this.title, required this.questionsCount});

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'] as int,
      title: json['title'] as String,
      questionsCount: json['questions_count'] as int,
    );
  }
}
