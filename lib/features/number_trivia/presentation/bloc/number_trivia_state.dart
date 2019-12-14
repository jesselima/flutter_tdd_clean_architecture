import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class NumberTriviaState extends Equatable {
 NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTriviaEntity numberTriviaEntity;
  Loaded({ @required this.numberTriviaEntity }) : super([numberTriviaEntity]);
}

class Error extends NumberTriviaState {
  final String message;
  Error({ @required this.message }) : super([message]);
}