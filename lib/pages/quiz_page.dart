import 'dart:async';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import 'package:projet_flutter/pages/finishedQuizpage.dart';
import 'package:projet_flutter/pages/review_page.dart';
import '../../../models/category.dart';
import '../../../models/question.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final QuizCategory category;

  const QuizPage({Key? key, required this.questions, required this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextStyle _questionStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  final HtmlUnescape unescape = HtmlUnescape();
  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late Timer _timer;
  int _timeLeft = 15;
  bool _timeUp = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timeUp = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _timeUp = true;
        });
        Future.delayed(Duration(seconds: 1), () {
          if (_currentIndex < (widget.questions.length - 1)) {
            _nextQuestion();
          } else {
            _submitQuiz();
          }
        });
      }
    });
  }

  void _nextQuestion() {
    if (_timer.isActive) _timer.cancel();
    setState(() {
      _currentIndex++;
    });
    _startTimer();
  }

  void _submitQuiz() {
    if (_timer.isActive) _timer.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ReviewPage(
          questions: widget.questions,
          answers: _answers,
          onReviewFinished: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => FinishedQuizPage(
                  questions: widget.questions,
                  answers: _answers,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getTimerColor() {
    if (_timeUp) return Colors.red;
    if (_timeLeft <= 5) return Colors.red;
    if (_timeLeft <= 10) return Colors.orange;
    return Color(0xFF789D88);
  }

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<String> options = List<String>.from(
      question.incorrectAnswers.map((e) => unescape.convert(e)),
    );

    final String correctAnswer = unescape.convert(question.correctAnswer);
    if (!options.contains(correctAnswer)) {
      options.add(correctAnswer);
      //options.shuffle(); // mélanger les réponses
    }

    final String decodedQuestion = unescape.convert(question.question);

    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            final shouldQuit = await showDialog<bool>(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text("Warning!"),
                  content: Text(
                      "Are you sure you want to quit the quiz? All your progress will be lost."),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes"),
                      onPressed: () {
                        if (_timer.isActive) _timer.cancel();
                        Navigator.pop(context, true);
                      },
                    ),
                    TextButton(
                      child: Text("No"),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ],
                );
              },
            );

            if (shouldQuit == true) {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.category.name, style: TextStyle(color: Colors.black)),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getTimerColor(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_timeLeft',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Text("${_currentIndex + 1}"),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Text(decodedQuestion),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        if (_timeUp)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              "Time's up!",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ...options.map(
                                  (option) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _timeUp
                                        ? Colors.grey[300]
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: RadioListTile(
                                    title: Text(option),
                                    groupValue: _answers[_currentIndex],
                                    value: option,
                                    onChanged: _timeUp
                                        ? null
                                        : (value) {
                                      setState(() {
                                        _answers[_currentIndex] = option;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            child: ButtonTheme(
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              minWidth: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _timeUp ? Color(0xFF789D88) : Color(0xFF789D88),
                  fixedSize: Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  _currentIndex == (widget.questions.length - 1)
                      ? "Submit"
                      : "Next",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _timeUp ? null : _nextSubmit,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must select an answer to continue.")),
      );
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      _nextQuestion();
    } else {
      _submitQuiz();
    }
  }
}