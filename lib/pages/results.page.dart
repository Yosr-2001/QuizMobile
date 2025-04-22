import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../models/question.dart';

class ResultsPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;
  final HtmlUnescape htmlUnescape = HtmlUnescape();

   ResultsPage({
    super.key,
    required this.questions,
    required this.answers,
  });

  String _decodeHtml(String html) {
    return htmlUnescape.convert(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Answers'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final userAnswer = answers[index];
                final isCorrect = question.correctAnswer == userAnswer;
                final decodedQuestion = _decodeHtml(question.question);
                final decodedUserAnswer = userAnswer != null ? _decodeHtml(userAnswer.toString()) : 'No answer';
                final decodedCorrectAnswer = _decodeHtml(question.correctAnswer);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          decodedQuestion,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Your answer: $decodedUserAnswer',
                          style: TextStyle(
                            color: isCorrect ? Colors.green : Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        if (!isCorrect)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Correct answer: $decodedCorrectAnswer',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(20, 30),
                backgroundColor: Color(0xFF789D88),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 18,color: Colors.white),

              ),
            ),
          ),
        ],
      ),
    );
  }
}