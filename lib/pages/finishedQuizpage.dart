import 'package:flutter/material.dart';
import '../../../models/question.dart';

class FinishedQuizPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  const FinishedQuizPage({Key? key, required this.questions, required this.answers}) : super(key: key);

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].correctAnswer == answers[i]) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final int score = _calculateScore();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Score', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text('$score / ${questions.length}', style: TextStyle(fontSize: 40, color: Colors.green)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Or go back to home
                },
                child: const Text("Back to Home"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
