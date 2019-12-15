import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

// Business logic or any conversion CAN NOT be implemented here!
class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {

  final String numberString;

  GetTriviaForConcreteNumberEvent(this.numberString) : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {

}
