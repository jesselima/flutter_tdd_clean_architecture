import 'package:flutter_tdd_clean_architecture/core/error/failures.dart';
import 'package:flutter_tdd_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';
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

  // ignore: close_sinks
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTriviaUseCase mockGetConcreteNumberTriviaUseCase;
  MockGetRandomNumberTriviaUseCase mockGetRandomNumberTriviaUseCase;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
    mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
    mockInputConverter = MockInputConverter();

    // Pass the mock to the bloc constructor
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


  /* TESTS FOR Get Trivia For CONCRETE Number */

  group('GetTriviaForConcreteNumber', () {

    final numberString = '1';
    final numberParsed = 1;
    final numberTriviaEntity = NumberTriviaEntity(number: 1, text: 'test trivia');

    void setupMockInputConverterSuccess() =>  when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(numberParsed));

    void setupMockInputConverterFailure() =>  when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Left(InvalidInputFailure()));


    test(
    'SHOULD call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // Arrange
        setupMockInputConverterSuccess();
        // Act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));
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
        setupMockInputConverterFailure();

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
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));

      },
    );

    test(
      'SHOULD get data from the concrete UseCase',
      () async {

        // Arrange
        setupMockInputConverterSuccess();

        // Arrange - Mock the UseCase
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Right(numberTriviaEntity));

        // Act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));
        await untilCalled(mockGetConcreteNumberTriviaUseCase(any));

        // Assert
        verify(mockGetConcreteNumberTriviaUseCase(Params(number: numberParsed)));

      },
    );


    test(
    'SHOULD emit [Loading, Loaded] when data is gotten successfuly',
      () async {

        // Arrange
        setupMockInputConverterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Right(numberTriviaEntity));

        // Assert later
        final expectedList = [
          Empty(), // OR bloc.initialState
          Loading(),
          Loaded(numberTriviaEntity: numberTriviaEntity)
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));

        // Act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));

      },
    );


    test(
    'SHOULD emit [Loading, Error] when getting data fails',
      () async {

        // Arrange
        setupMockInputConverterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // Assert later
        final expectedList = [
          Empty(), // OR bloc.initialState
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));

        // Act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));

      },
    );


    test(
      'SHOULD emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {

        // Arrange
        setupMockInputConverterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // Assert later
        final expectedList = [
          Empty(), // OR bloc.initialState
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));

        // Act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));

      },
    );

  });


  /* TESTS FOR Get RANDOM Trivia */

  group('GetTriviaForRandomNumber', () {

    final numberTriviaEntity = NumberTriviaEntity(number: 1, text: 'test trivia');


    test(
      'SHOULD get data from the random UseCase',
      () async {

        // Arrange - Mock the UseCase
        when(mockGetRandomNumberTriviaUseCase(any)) // Could be NoParams(). But we do it on verity part
            .thenAnswer((_) async => Right(numberTriviaEntity));

        // Act
        bloc.add(GetTriviaForRandomNumberEvent());
        await untilCalled(mockGetRandomNumberTriviaUseCase(any));

        // Assert
        verify(mockGetRandomNumberTriviaUseCase(NoParams()));

      },
    );


    test(
      'SHOULD emit [Loading, Loaded] when random data is gotten successfuly',
          () async {

        // Arrange
        when(mockGetRandomNumberTriviaUseCase(any))
            .thenAnswer((_) async => Right(numberTriviaEntity));

        // Assert later
        final expectedList = [
          Empty(), // OR bloc.initialState
          Loading(),
          Loaded(numberTriviaEntity: numberTriviaEntity)
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));

        // Act
        bloc.add(GetTriviaForRandomNumberEvent());

      },
    );


    test(
      'SHOULD emit [Loading, Error] when getting random data fails',
          () async {

        // Arrange
        when(mockGetRandomNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // Assert later
        final expectedList = [
          Empty(), // OR bloc.initialState
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));

        // Act
        bloc.add(GetTriviaForRandomNumberEvent());

      },
    );


    test(
      'SHOULD emit [Loading, Error] with a proper message for the error when getting random data fails',
          () async {

        // Arrange
        when(mockGetRandomNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(CacheFailure()));



        // Assert later
        final expectedList = [
          Empty(), // OR bloc.initialState
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc.state, emitsInOrder(expectedList));

        // Act
        bloc.add(GetTriviaForRandomNumberEvent());

      },
    );

  });

}