import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository { }

void main() {

  // Declare objects instances for testing
  GetConcreteNumberTriviaUseCase useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  // Setup runs before every single test
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTriviaUseCase(mockNumberTriviaRepository);
  });


  final tNumber = 1;
  final tNumberTrivia = NumberTriviaEntity(number: 1, text: 'test',);


  test(
  'should get trivia for the number from the repository',
    () async {

      // Arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia)); // Right means success in Either.
      
      // Act
      final result = await useCase(Params(number: tNumber));

      // Assert
      expect(result, Right(tNumberTrivia));
      // Using mockito
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );



}