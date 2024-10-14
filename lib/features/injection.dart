import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'profile/data/datasources/local_datasource.dart';
import 'profile/data/datasources/remote_datasource.dart';
import 'profile/data/repositories/profile_repository_implementation.dart';
import 'profile/domain/repositories/profile_repository.dart';
import 'profile/domain/usecases/get_all_user.dart';
import 'profile/presentation/bloc/profile_bloc.dart';

import 'profile/data/models/profile_model.dart';
import 'profile/domain/usecases/get_user.dart';

var myInjection = GetIt.instance; // tempat penampungan semua dependences

Future<void> init() async {
  // ========= General Dependences (meng inject semua dependences)
  // Hive
  Hive.registerAdapter(ProfileModelAdapter());
  var box = await Hive.openBox("profile_box");

  myInjection.registerLazySingleton(
    () => box,
  );

  // Http
  myInjection.registerLazySingleton(
    () => http.Client(),
  );
  // ========= Feature - profile
  // Bloc
  myInjection.registerFactory(
      () => ProfileBloc(getAllUser: myInjection(), getUser: myInjection()));

  // usecase
  myInjection.registerLazySingleton(
    () => GetAllUser(myInjection()),
  );
  myInjection.registerLazySingleton(
    () => GetUser(myInjection()),
  );

  // repository
  myInjection.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImplementation(
        profileRemoteDataSource: myInjection(),
        profileLocalDataSource: myInjection(),
        box: box),
  );

  // data source
  myInjection.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImplementation(box: box),
  );

  myInjection.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImplementation(
      client: myInjection(),
    ),
  );
}
