class Quiz {
  final String question;
  final String correctAnswer;
  final List<String> wrongAnswers;

  Quiz({this.question, this.correctAnswer, this.wrongAnswers});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      correctAnswer: json['correct_answer'],
      wrongAnswers: List<String>.from(json["incorrect_answers"].map((x) => x)),
    );
  }
}
