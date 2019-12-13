
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:meta/meta.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  NumberTriviaModel({
    @required String text,
    @required int number
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        text: json['text'],
        number: (json['number'] as num).toInt(), // "num" can be a integer or double as well.
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "number": number,
    };
  }

}