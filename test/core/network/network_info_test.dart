import 'package:flutter_tdd_clean_architecture/core/network/network_info_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';


class MockDataConnectionChecker extends Mock implements DataConnectionChecker { }


void main() {

  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });


  group('isConnected', () {

      test(
        'SHOULD V1 forward the call to DataConnectionChecker.hasConnection',
        () async {
          // Arrange
          when(mockDataConnectionChecker.hasConnection)
              .thenAnswer((_) async => true);

          // Act
          final result = await networkInfoImpl.isConnected;

          // Assert
          verify(mockDataConnectionChecker.hasConnection);
          expect(result, true);

        },
      );

      test(
        'SHOULD V2 forward the call to DataConnectionChecker.hasConnection',
        () async {
          // Now the results will be a Future holding a boolean value
          final tHasConnection = Future.value(true);

          // Arrange
          when(mockDataConnectionChecker.hasConnection)
              .thenAnswer((_) async => tHasConnection);

          // Act
          final result = await networkInfoImpl.isConnected;

          // Assert
          verify(mockDataConnectionChecker.hasConnection);
          expect(result, tHasConnection);

        },
      );
  });



}
