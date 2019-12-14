import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_tdd_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia_use_case.dart';
import './bloc.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {

  final GetConcreteNumberTriviaUseCase concreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase randomNumberTriviaUseCase;
  final InputConverter inputConverter;

  // *** Instaed to use a conventional constructor e need to be sure the the constructor arguments are not null
  // NumberTriviaBloc({ 
  //     @required this.concreteNumberTriviaUseCase, 
  //     @required this.randomNumberTriviaUseCase, 
  //     @required this.inputConverter
  // });

  NumberTriviaBloc({ 
      @required GetConcreteNumberTriviaUseCase concrete, 
      @required GetRandomNumberTriviaUseCase random, 
      @required this.inputConverter
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        concreteNumberTriviaUseCase = concrete,
        randomNumberTriviaUseCase = random;


  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
