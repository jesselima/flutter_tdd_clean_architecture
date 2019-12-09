import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:matcher/matcher.dart';

import 'package:flutter_tdd_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source_impl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}


void main() {

  const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

  // Declare objects
  NumberTriLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    // Setup objects
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });


  ///
  /// Tests for getLastNumberTrivia group
  ///

  group("getLastNumberTrivia", () {

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia_cache.json")));

    test(
      "SHOULD returnn NumberTrivia from SharedPreferences when there is one in the cache",
      () async {
        // Arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture("trivia_cache.json"));
        // Act
        final result = await dataSource.getLastNumberTrivia();
        // Assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "SHOULD throw a CacheException qhen there not a cached value",
      () async {
        // Arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // Act
        final call = dataSource.getLastNumberTrivia; // Method Reference
        // Assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );

  });


  ///
  /// Tests for cacheNumberTrivia group
  ///

    group("cacheNumberTrivia", () {

      final numberTriviaModelToCache = NumberTriviaModel(number: 1, text: "number trivia");

        test(
          "SHOULD call preferences to cache data",
          () async {
            // Act
            dataSource.cacheNumberTrivia(numberTriviaModelToCache);
            // Assert
            final expectedJsonString = json.encode(numberTriviaModelToCache.toJson());
            verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
          }
        );
    });

}
