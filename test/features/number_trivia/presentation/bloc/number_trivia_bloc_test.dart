import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui' as ui;

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

  group('GetTriviaForConcreteNumber', () {

    final numberString = '1';
    final numberParsed = 1;
    final numberTrivia = NumberTriviaEntity(number: 1, text: 'test trivia');

    test(
    'SHOULD call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // Arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(numberParsed));
        // Act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString));
        // IF we do not wait the method to be called the test will failure.
        // ...with this next line the test will hold and wait until the method is called.
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // Assert
        verify(mockInputConverter.stringToUnsignedInteger(numberString));
      },
    );

    test(
    'SHOULD emit [Error] when the input is invalid ',
      () async {

        // Arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        // ASSERT
        final expectedList = [
            Empty(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));

        // ACT - TO AVOID THE BLOC EXECUTION TO COMPLETE BEFORE THE dispatch() CALL THE "ACT" COMES LATER
        // ... THIS WAY WE CAN BE 100% SURE THAT WHEN BLOC IS EXECUTED IT WILL MEET THE EXPECTATION.
        // Video Reference: [11] – Bloc Implementation 1/2 - Seek: 25:46
        // the dispatch does not return anything. That is why we need to use bloc.state to notify
        bloc.dispatch(GetTriviaForConcreteNumber(numberString));

      },
    );

  });

}