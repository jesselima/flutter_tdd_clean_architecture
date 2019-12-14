import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia_use_case.dart';


class MockGetConcreteNumberTriviaUseCase extends Mock implements GetConcreteNumberTriviaUseCase { }

class MockGetRandomNumberTriviaUseCase extends Mock implements GetRandomNumberTriviaUseCase { }

class MockInputConverter extends Mock implements InputConverter { }


void main() {

  NumberTriviaBloc bloc;
  MockGetConcreteNumberTriviaUseCase mockGetConcreteNumberTriviaUseCase;
  MockGetRandomNumberTriviaUseCase mockGetRandomNumberTriviaUseCase;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
    mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
    mockInputConverter = MockInputConverter();

    // Pass the mock to the bloc cusntructor
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTriviaUseCase,
        random: mockGetRandomNumberTriviaUseCase,
        inputConverter: mockInputConverter
      );
  });

  test('Initial State should be empty ...', () {
    // Assert
    expect(bloc.initialState, equals(Empty()));
    
  });


}