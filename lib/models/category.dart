import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuizCategory {
  final int id;
  final String name;
  final dynamic icon; // optionnel

  QuizCategory(this.id, this.name, {this.icon});

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      json['id'],
      json['name'],
      icon: getCategoryIcon(json['id']), // mapping icône
    );
  }
}

IconData? getCategoryIcon(int id) {
  switch (id) {
    case 9:
      return FontAwesomeIcons.globeAsia;
    case 10:
      return FontAwesomeIcons.bookOpen;
    case 11:
      return FontAwesomeIcons.video;
    case 12:
      return FontAwesomeIcons.music;
    case 13:
      return FontAwesomeIcons.theaterMasks;
    case 14:
      return FontAwesomeIcons.tv;
    case 15:
      return FontAwesomeIcons.gamepad;
    case 16:
      return FontAwesomeIcons.chessBoard;
    case 17:
      return FontAwesomeIcons.microscope;
    case 18:
      return FontAwesomeIcons.laptopCode;
    case 19:
      return FontAwesomeIcons.sortNumericDown;
    case 21:
      return FontAwesomeIcons.footballBall;
    case 22:
      return FontAwesomeIcons.mountain;
    case 23:
      return FontAwesomeIcons.monument;
    case 25:
      return FontAwesomeIcons.paintBrush;
    case 27:
      return FontAwesomeIcons.dog;
    case 28:
      return FontAwesomeIcons.carAlt;
    case 30:
      return FontAwesomeIcons.mobileAlt;
    default:
      return FontAwesomeIcons.circleQuestion; // icône par défaut
  }
}
