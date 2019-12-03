
import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failures.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {

  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  // The name of the method "call" stands for the Callable class in Dart.
  Future<Either<Failure, NumberTrivia>> call({ @required int number }) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}