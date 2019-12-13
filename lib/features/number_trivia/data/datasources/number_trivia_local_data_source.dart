import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class NumberTriviaLocalDataSource {

  /// Gets the cached [NumberTriviaEntity] which was gotten the last time
  /// the user had an internet connection.
  /// Throws [CacheDataException] if no cached data is present.
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModelToCache);

  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

}