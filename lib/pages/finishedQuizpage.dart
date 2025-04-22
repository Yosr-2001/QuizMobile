import 'package:flutter/material.dart';
import 'package:projet_flutter/pages/results.page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_flutter/pages/home.page.dart';
import '../../models/question.dart';

class FinishedQuizPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;
  final String? difficulty;

  FinishedQuizPage({
    Key? key,
    required this.questions,
    required this.answers,
    this.difficulty,
  }) : super(key: key);

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].correctAnswer == answers[i]) {
        score++;
      }
    }
    return score;
  }

  Future<void> _playSoundEffect(int score) async {
    // Audio désactivé pour éviter erreurs de compilation liées à audioplayers.
    // Tu peux réactiver cette fonction plus tard si nécessaire.
  }

  Future<void> _saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = difficulty != null
        ? 'highscore_${difficulty}_${questions.length}'
        : 'highscore_${questions.length}';

    final currentHighScore = prefs.getInt(key) ?? 0;

    if (score > currentHighScore) {
      await prefs.setInt(key, score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int score = _calculateScore();
    _saveHighScore(score);
    _playSoundEffect(score);

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
              SizedBox(height: 20),
              FutureBuilder(
                future: _getHighScore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      'Best Score: ${snapshot.data ?? 0}/${questions.length}',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsPage(
                        questions: questions,
                        answers: answers,
                      ),
                    ),
                  );
                },
                child: const Text("Review Answers", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF789D88),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text("Back to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final key = difficulty != null
        ? 'highscore_${difficulty}_${questions.length}'
        : 'highscore_${questions.length}';
    return prefs.getInt(key) ?? 0;
  }
}
