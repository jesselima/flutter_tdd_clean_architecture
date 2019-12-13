
import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import '../../../../features/number_trivia/domain/entities/number_trivia_entity.dart';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {

  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({ @required this.client });

  /// Calls the http://numbersapi.com/{number} endpoint.
  /// Throws a [ServerException] for all error codes.
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
     final response = await client.get(
         'http://numbersapi.com/$number',
         headers: {
           'Content-Type': 'aplication/json'
         }
     );

     if (response.statusCode == 200) {
       return NumberTriviaModel.fromJson(json.decode(response.body));
     } else {
       throw ServerException();
     }

  }

  /// Calls the http://numbersapi.com/random endpoint.
  /// Throws a [ServerException] for all error codes.
  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await client.get(
        'http://numbersapi.com/random',
        headers: {
          'Content-Type': 'aplication/json'
        }
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

}