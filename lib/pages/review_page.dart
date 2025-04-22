import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:projet_flutter/pages/finishedQuizpage.dart';
import '../../models/question.dart';

class ReviewPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;
  final VoidCallback onReviewFinished;
  late final HtmlUnescape htmlUnescape = HtmlUnescape();

   ReviewPage({
    required this.questions,
    required this.answers,
    required this.onReviewFinished,
    super.key,
  });

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].correctAnswer == answers[i]) {
        score++;
      }
    }
    return score;
  }

  String _decodeHtml(String html) {
    return htmlUnescape.convert(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Questions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final answer = answers[index];
                final decodedQuestion = _decodeHtml(question.question);
                final decodedAnswer = answer != null ? _decodeHtml(answer.toString()) : null;

                return ListTile(
                  title: Text(decodedQuestion),
                  subtitle: Text(decodedAnswer != null
                      ? 'Given Answer : $decodedAnswer'
                      : 'No Answer'),
                  trailing: Icon(
                    answer != null ? Icons.check_circle : Icons.cancel,
                    color: answer != null ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                final score = _calculateScore();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FinishedQuizPage(
                      questions: questions,
                      answers: answers,
                    ),
                  ),
                );
                onReviewFinished();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Color(0xFF789D88),
              ),
              child: const Text('Finish',style: TextStyle(color:Colors.white))
                
            ),
          ),
        ],
      ),
    );
  }
}