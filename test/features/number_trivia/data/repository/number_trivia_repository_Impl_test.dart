import 'package:flutter_tdd_clean_architecture/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/repositoriesmpl/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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

}


