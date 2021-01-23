import 'package:flutter/material.dart';
import 'package:tdd_app/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required String text,
    @required int number,
  }) : super(
          text: text,
          number: number,
        );

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson(NumberTriviaModel numberTriviaModel) {
    return {
      'text': numberTriviaModel.text,
      'number': numberTriviaModel.number,
    };
  }
}
