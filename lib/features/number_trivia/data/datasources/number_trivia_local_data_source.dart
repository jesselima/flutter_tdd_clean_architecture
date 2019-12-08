import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class NumberTriviaLocalDataSource {

  /// Gets the cached [NumberTrivia] which was gotten the last time
  /// the user had an internet connection.
  /// Throws [CacheDataException] if no cached data is present.
  Future<NumberTrivia> getNumberTriviaDataSource();

  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTrivia numberTriviaToCache);

}