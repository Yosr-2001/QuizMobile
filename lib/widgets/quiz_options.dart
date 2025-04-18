import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projet_flutter/models/category.dart';
import 'package:projet_flutter/models/question.dart';
import 'package:projet_flutter/pages/error.page.dart';
import 'package:projet_flutter/pages/quiz_page.dart';
import 'package:projet_flutter/ressources/api_provider.dart';

class QuizOptionsDialog extends StatefulWidget {
  final QuizCategory category;

  const QuizOptionsDialog({Key? key, required this.category}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  late int _noOfQuestions;
  late String _difficulty;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF789D88); // Bleu clair

    final backgroundColor1 = const Color(0xFFFFFFFF);
    final backgroundColor2 = const Color(0xFFFFFFFF);
    final textColor = const Color(0xFF2C3E50);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Selected category : "+
                widget.category.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 30.0),
              _buildSectionTitle("Nombre de questions", textColor),
              _buildChips(
                [10, 20, 30, 40, 50],
                _noOfQuestions,
                (val) => _selectNumberOfQuestions(val),
                primaryColor,
                backgroundColor1,
              ),
              const SizedBox(height: 25.0),
              _buildSectionTitle("Difficulté", textColor),
              _buildChips(
                ["null", "easy", "medium", "hard"],
                _difficulty,
                (val) => _selectDifficulty(val),
                primaryColor,
                backgroundColor2,
                labels: ["Tous", "Facile", "Moyen", "Difficile"],
              ),
              const SizedBox(height: 40.0),
              processing
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  elevation: 3,
                ),
                onPressed: _startQuiz,
                icon: const Icon(Icons.play_arrow, color: Colors.white), // ← 👈 Icône ajoutée ici
                label: const Text(
                  "Commencer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),

                SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildChips<T>(
    List<T> values,
    T selectedValue,
    Function(T) onSelect,
    Color selectedColor,
    Color backgroundColor, {
    List<String>? labels,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: values.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          final label = labels != null ? labels[index] : value.toString();

          return ChoiceChip(
            label: Text(label),
            selected: selectedValue == value,
            selectedColor: selectedColor,
            backgroundColor: backgroundColor,
            labelStyle: TextStyle(
              color: selectedValue == value ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (_) => onSelect(value),
          );
        }).toList(),
      ),
    );
  }

  void _selectNumberOfQuestions(int number) {
    setState(() {
      _noOfQuestions = number;
    });
  }

  void _selectDifficulty(String diff) {
    setState(() {
      _difficulty = diff;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });

    try {
      List<Question> questions =
          await getQuestions(widget.category, _noOfQuestions, _difficulty);
      Navigator.pop(context);

      if (questions.isEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const ErrorPage(
            message:
                "Il n’y a pas assez de questions disponibles avec les options choisies.",
          ),
        ));
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizPage(
            questions: questions,
            category: widget.category,
          ),
        ),
      );
    } on SocketException {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ErrorPage(
            message:
                "Impossible de se connecter à Internet.\nVeuillez vérifier votre connexion.",
          ),
        ),
      );
    } catch (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ErrorPage(
            message: "Une erreur inattendue est survenue.",
          ),
        ),
      );
    } finally {
      setState(() {
        processing = false;
      });
    }
  }
}
