import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd_clean_architecture/core/network/network_info.dart';
import 'package:flutter_tdd_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failures.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/repositoriesmpl/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';


/// Setup Mocks
///
class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource { }

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource { }

class MockNetworkInfo extends Mock implements NetWorkInfo { }


void main(){

  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource  mockRemoteDataSource;
  MockLocalDataSource   mockLocalDataSource;
  MockNetworkInfo       mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource  = MockRemoteDataSource();
    mockLocalDataSource   = MockLocalDataSource();
    mockNetworkInfo       = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo
    );

  });

  void runTestOnLine(Function function) {
    group('device is online', () {

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      function();

    });
  }

  void runTestOffLine(Function function) {
    group('device is offline', () {

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      function();

    });
  }

  group('getConcreteNumberTrivia', () {

    final number = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: number, text: 'test trivia');
    final NumberTriviaEntity tNumberTrivia = tNumberTriviaModel;

    test(
      'SHOULD check if device is online',
      () async {
        // Arrange - Forces the Network info return always true for test
        // thenAnswer() returns a Future. For Non
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Act - Call the repository method and pass a dummy data
        repository.getConcreteNumberTrivia(number);
        // Assert - Check if the NetworkInfo.isConnect() have been called.
        verify(mockNetworkInfo.isConnected);
      },
    );
    
    
    runTestOnLine(() {

      test(
      //SHOULD action WHEN circumstances',
      'SHOULD return remote data WHEN tha call remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          final result = await repository.getConcreteNumberTrivia(number);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          expect(result, equals(Right(tNumberTrivia))); // Not the Model, but The Entity
        },
      );

      test(
        //SHOULD action WHEN circumstances',
        'SHOULD cache the data locally WHEN tha call remote data source is successful',
            () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          await repository.getConcreteNumberTrivia(number);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'SHOULD return server failure WHEN tha call remote data source is unsuccessful',
            () async {

          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());

          // Act
          final result = await repository.getConcreteNumberTrivia(number);

          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          // make sure that when there is a server error mockLocalDataSource is not toughed
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure()))); // Not the Model, but The Entity
        },
      );

    });



    runTestOffLine(() {

      test(
      'SHOULD return last locally cached data when the cache data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          final result = await repository.getConcreteNumberTrivia(number);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
      'SHOULD return CacheFailure data when there is no cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final result = await repository.getConcreteNumberTrivia(number);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );

    });

  });


  ///
  /// Tests for Random Number trivia
  ///

  group('getRandomNumberTrivia', () {

    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTriviaEntity tNumberTrivia = tNumberTriviaModel;

    test(
      'SHOULD check if device is online',
      () async {
        // Arrange - Forces the Network info return always true for test
        // thenAnswer() returns a Future. For Non
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Act - Call the repository method and pass a dummy data
        repository.getRandomNumberTrivia();
        // Assert - Check if the NetworkInfo.isConnect() have been called.
        verify(mockNetworkInfo.isConnected);
      },
    );


    runTestOnLine(() {

      test(
      //SHOULD action WHEN circumstances',
      'SHOULD return remote data WHEN tha call remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia))); // Not the Model, but The Entity
        },
      );

      test(
        //SHOULD action WHEN circumstances',
        'SHOULD cache the data locally WHEN tha call remote data source is successful',
            () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
          'SHOULD return server failure WHEN tha call remote data source is unsuccessful',
          () async {

            // Arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());

            // Act
            final result = await repository.getRandomNumberTrivia();

            // Assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            // make sure that when there is a server error mockLocalDataSource is not toughed
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure()))); // Not the Model, but The Entity
          },
      );

    });



    runTestOffLine(() {

      test(
      'SHOULD return last locally cached data when the cache data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
      'SHOULD return CacheFailure data when there is no cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );

    });

  });

}


