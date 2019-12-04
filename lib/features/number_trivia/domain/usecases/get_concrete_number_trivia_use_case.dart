
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/number_trivia/domain/entities/number_trivia_entity.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase implements UseCase<NumberTrivia, Params> {

  final NumberTriviaRepository repository;

  GetConcreteNumberTriviaUseCase(this.repository);

  // The name of the method "call" stands for the Callable class in Dart.
  @override
  Future<Either<Failure, NumberTrivia>> call(
      Params params,
  ) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}


class Params extends Equatable {

  final int number;

  Params({ @required this.number }) : super([number]);

}