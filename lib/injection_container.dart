import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_tdd_clean_architecture/core/network/network_info.dart';
import 'package:flutter_tdd_clean_architecture/core/network/network_info_impl.dart';
import 'package:flutter_tdd_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source_impl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source_impl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/repositoriesmpl/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia_use_case.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

final getIt = GetIt.instance;

// This function is retuning a Future due to SharedPreferences
Future<void> init() async {

  // NOTES
  /* NOTES
  * registerLazySingleton will always return the same first created instance
  * serviceLocator.registerLazySingleton(func)...
  * => Classes requiring cleanup (such as Blocs) shouldn't be registered as Singletons
  *
  *  RegisterFactory will always return a news instance.
  *  'serviceLocator()' == 'serviceLocator.call()'
  * */


  /* ********* Features - Number Trivia ************ */

  /// Bloc
  getIt.registerFactory(
    () => NumberTriviaBloc(
      concrete: getIt(),
      random: getIt(),
      inputConverter: getIt()
    ),
  );

  /// Use Cases
  // registerLazySingleton will be initialized only when is requested as dependency for some class.
  getIt.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRandomNumberTriviaUseCase(getIt()));

  /// Repository (Remember it's an abstract class that can not be instantiated)
  getIt.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource:  getIt(),
        networkInfo:      getIt()
    )
  );

  /// Data Sources
  getIt.registerLazySingleton<NumberTriviaRemoteDataSource>(
          () => NumberTriviaRemoteDataSourceImpl(client: getIt())
  );

  getIt.registerLazySingleton<NumberTriviaLocalDataSource>(
          () => NumberTriviaLocalDataSourceImpl(sharedPreferences: getIt())
  );


  /* ********* CORE ********* */
  getIt.registerLazySingleton(() => InputConverter());
  getIt.registerLazySingleton<NetWorkInfo>(() => NetworkInfoImpl(getIt()));


  /* ********* EXTERNAL DEPENDENCIES ********* */
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => DataConnectionChecker());

}



void initFeatures() {

}


void initCore() {

}


void initExternalDependencies() {

}





