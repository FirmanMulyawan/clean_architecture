import 'package:my_clean_architecture/features/profile/data/datasources/remote_datasource.dart';

void main() async {
  final ProfileRemoteDataSourceImplementation
      profileRemoteDataSourceImplementation =
      ProfileRemoteDataSourceImplementation();

  // var response = await profileRemoteDataSourceImplementation.getAllUser(1);
  var response = await profileRemoteDataSourceImplementation.getUser(1);

  // print(response.toJson());
}
