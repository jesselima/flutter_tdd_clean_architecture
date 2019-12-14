import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {

    test(
      'SHOULD return an integer when the string represents a unsigned integer', 
      () async {
        // Arrange
        final str = '123';
        // Act
        final actual = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(actual, Right(123));
      }
    );


    test(
      'SHOULD return a failure when the string is not a integer', 
      () async {
        // Arrange
        final str = 'abc';
        // Act
        final actual = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(actual, Left(InvalidInputFailure()));
      }
    );

    test(
      'SHOULD return a failure when the string is a negative integer', 
      () async {
        // Arrange
        final str = '-123';
        // Act
        final actual = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(actual, Left(InvalidInputFailure()));
      }
    );

  });


}