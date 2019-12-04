
import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failures.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:meta/meta.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase {

  final NumberTriviaRepository repository;


  GetConcreteNumberTriviaUseCase(this.repository);

  // The name of the method "call" stands for the Callable class in Dart.
  Future<Either<Failure, NumberTrivia>> call({ @required int number }) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}