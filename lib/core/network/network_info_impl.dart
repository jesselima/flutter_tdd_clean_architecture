import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_tdd_clean_architecture/core/network/network_info.dart';

class NetworkInfoImpl implements NetWorkInfo {

  final DataConnectionChecker dataConnectionChecker;

  NetworkInfoImpl(this.dataConnectionChecker);

  // isConnected() just forward the value os hasConnection
  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;

}