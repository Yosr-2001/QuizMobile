import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:projet_flutter/models/category.dart';
import 'package:projet_flutter/models/question.dart';

const String baseUrl = "https://opentdb.com/api.php";

const String categoryUrl = "https://opentdb.com/api_category.php";

Future<List<QuizCategory>> getCategories() async {
  final response = await http.get(Uri.parse(categoryUrl));

  if (response.statusCode == 200) {
    final List<dynamic> categoryJson = json.decode(response.body)['trivia_categories'];
    return categoryJson.map((json) => QuizCategory.fromJson(json)).toList();
  } else {
    throw Exception('Erreur lors de la récupération des catégories');
  }
}




Future<List<Question>> getQuestions(
    QuizCategory category, int total, String difficulty) async {
  String url = "$baseUrl?amount=$total&category=${category.id}";
  if (difficulty != "null") {
    url = "$url&difficulty=$difficulty";
  }
  http.Response res = await http.get(Uri.parse(url));
  List<Map<String, dynamic>> questions =
  List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return Question.fromData(questions);
}