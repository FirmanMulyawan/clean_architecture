import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import 'package:my_clean_architecture/core/error/failure.dart';

import 'package:my_clean_architecture/features/profile/domain/entities/profile.dart';

import '../../domain/repositories/profile_repository.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImplementation extends ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ProfileLocalDataSource profileLocalDataSource;
  final HiveInterface hive;

  ProfileRepositoryImplementation(
      {required this.profileRemoteDataSource,
      required this.profileLocalDataSource,
      required this.hive});

  @override
  Future<Either<Failure, List<Profile>>> getAllUser(int page) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        // no internet
        List<ProfileModel> result =
            await profileLocalDataSource.getAllUser(page);
        return Right(result);
      } else {
        List<ProfileModel> result =
            await profileRemoteDataSource.getAllUser(page);
        // put data last data to box local
        var box = hive.box("profile_box");
        box.put("getAllUser", result);
        return Right(result);
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, Profile>> getUser(int id) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        // no internet
        ProfileModel result = await profileLocalDataSource.getUser(id);
        return Right(result);
      } else {
        ProfileModel result = await profileRemoteDataSource.getUser(id);
        // put data last data to box local
        var box = hive.box("profile_box");
        box.put("getUser", result);
        return Right(result);
      }
    } catch (e) {
      return Left(Failure());
    }
  }
}
