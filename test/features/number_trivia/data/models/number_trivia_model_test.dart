import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {

  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test(
  'should be a subclass of NumberTrivia entity',
    () async {

      // Arrange
      expect(tNumberTriviaModel, isA<NumberTriviaEntity>());

    },
  );

  group('fromJson', () {

    test(
    'should return a valid model when JSON number is an integer',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // Assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should retirn a valid model when JSON number is regarded as a double',
          () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // Assert
        expect(result, tNumberTriviaModel);
      },
    );


  });


  group('toJson', () {

    test(
      'should return a JSOn Map containing the proper data',
      () async {
        // Act
        final result = tNumberTriviaModel.toJson();
        // Assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };

        expect(result, expectedMap);
      },
    );

  });



}