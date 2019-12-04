import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia_use_case.dart';


class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository { }

void main() {

  // Declare objects instances for testing
  GetRandomNumberTriviaUseCase useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  // Setup runs before every single test
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTriviaUseCase(mockNumberTriviaRepository);
  });


  final tNumberTrivia = NumberTrivia(number: 1, text: 'test',);


  test(
    'should get trivia from the repository',
        () async {

      // Arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia)); // Right means success in Either.

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, Right(tNumberTrivia));
      // Using mockito
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );



}