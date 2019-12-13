
import 'package:flutter_tdd_clean_architecture/core/error/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source_impl.dart';
import '../../../../fixtures/fixture_reader.dart';


class MockHttpClient extends Mock implements http.Client {}

void main() {

  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });


  /// Setup the http mocks
  void setupMockHttpSuccessClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpSuccessClientFailure404({ int statusCode }) {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('some wrong argument url', 404));
  }


  group('getConcreteNumberTrivia', () {

      int number = 1;
      final numberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));


      /* TESTS FOR SUCCESS RESPONSE CASES */

      test(
        '''SHOULD perform a get request ona URL with a number being the 
           andpoint and with application/json header''',
        () async {
          // Arrange
          setupMockHttpSuccessClientSuccess200();
          // Act
          dataSource.getConcreteNumberTrivia(number);
          // Assert - check if the call have been made with the proper headers and url.
          verify(mockHttpClient.get(
              'http://numbersapi.com/$number',
              headers: { 'Content-Type': 'aplication/json'}
          ));
        },
      );

      test(
        'SHOULD return NumberTrivia when the response code is 200 (success)',
        () async {
          // Arrange
          setupMockHttpSuccessClientSuccess200();
          // Act
          final actual = await dataSource.getConcreteNumberTrivia(number);
          // Assert - check if the call have been made with the proper headers and url.
          expect(actual, equals(numberTriviaModel));
        },
      );

      /* TESTS FOR FAILURE RESPONSES CASES */

      test(
      'SHOULD throw ServerException when the response code is 404 or other',
        () async {
          // Arrange
          setupMockHttpSuccessClientFailure404();
          // Act
          final call = dataSource.getConcreteNumberTrivia;
          // assert
          expect(() => call(number), throwsA(TypeMatcher<ServerException>()));
        },
      );

  });

}