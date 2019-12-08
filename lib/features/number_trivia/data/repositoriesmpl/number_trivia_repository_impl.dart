import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/platform/network_info.dart';
import '../../data/datasources/number_trivia_local_data_source.dart';
import '../../data/datasources/number_trivia_remote_data_source.dart';
import '../../domain/entities/number_trivia_entity.dart';
import '../../domain/repositories/number_trivia_repository.dart';

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
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    if(await networkInfo.isConnected) {
      try {
        final remoteTriviaToCache = await remoteDataSource.getConcreteNumberTrivia(number);
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

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if(await networkInfo.isConnected) {
      try {
        final remoteTriviaToCache = await remoteDataSource.getRandomNumberTrivia();
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