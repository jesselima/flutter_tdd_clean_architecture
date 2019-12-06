import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class NumberTriviaLocalDataSource {

  /// Gets the cached [NumberTrivia] which was gotten the last time
  /// the user had an internet connection.
  /// Throws [CacheDataException] if no cached data is present.
  Future<NumberTrivia> getNumberTriviaDataSource();

  Future<void> cacheNumberTrivia(NumberTrivia numberTriviaToCache);

}