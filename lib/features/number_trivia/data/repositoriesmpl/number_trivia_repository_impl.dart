import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/number_trivia_local_data_source.dart';
import '../../data/datasources/number_trivia_remote_data_source.dart';
import '../../domain/entities/number_trivia_entity.dart';
import '../../domain/repositories/number_trivia_repository.dart';


typedef Future<NumberTriviaEntity> _ConcreteOrRandomChooser();


class NumberTriviaRepositoryImpl implements NumberTriviaRepository {

  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetWorkInfo networkInfo;

  NumberTriviaRepositoryImpl({
      @required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
        return remoteDataSource.getRandomNumberTrivia();
    });
  }

  // This a high order function to avoid code duplication
  Future<Either<Failure, NumberTriviaEntity>> _getTrivia(
      //Future<NumberTrivia> Function() getConcreteOrRandom // Function() means the function get no arguments
      _ConcreteOrRandomChooser getConcreteOrRandom
      ) async {

    if(await networkInfo.isConnected) {
      try {
        // This is the only different line of code
        final remoteTriviaToCache = await getConcreteOrRandom();

        localDataSource.cacheNumberTrivia(remoteTriviaToCache);
        return Right(remoteTriviaToCache);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

}