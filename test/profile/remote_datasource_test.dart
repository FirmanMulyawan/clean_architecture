// instruction for generate coverage

// ==> flutter pub get
// ==> dart run build_runner build --delete-conflicting-outputs

// ==> flutter test --machine > tests.outuput

// test semua folder yang ada di test
// ==> flutter test --coverage

// test spesific folder yang ada di test
// ==> flutter test test/profile --coverage

// generate html
// ==> genhtml coverage/lcov.info -o coverage/html --legend -t "Clean Architecture by Firman Mulyawan" --function-coverage

// open html
// ==> open coverage/html/index.html

// ==> remove
// ==> lcov --remove coverage/lcov.info "lib/core/error/*" "lib/features/profile/data/models/*" -o coverage/lcov.info
import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:my_clean_architecture/core/error/exception.dart';
import 'package:my_clean_architecture/features/profile/data/datasources/remote_datasource.dart';
import 'package:my_clean_architecture/features/profile/data/models/profile_model.dart';

@GenerateNiceMocks(
    [MockSpec<ProfileRemoteDataSource>(), MockSpec<http.Client>()])
import 'remote_datasource_test.mocks.dart';

void main() {
  var remoteDataSource = MockProfileRemoteDataSource();
  MockClient mockClient = MockClient();
  var remoteDataSourceImplementation =
      ProfileRemoteDataSourceImplementation(client: mockClient);

  // stub -> kondisi untuk kita palsukan
  const int userId = 1;
  const int page = 1;
  Uri urlGetAllUser = Uri.parse('https://reqres.in/api/users?page=$page');
  Uri urlGetUser = Uri.parse('https://reqres.in/api/users/$userId');

  Map<String, dynamic> fakeDataJson = {
    "id": userId,
    "email": "userId@gmail.com",
    "first_name": "user",
    "last_name": "$userId",
    "avatar": "https://image.com/$userId",
  };

  ProfileModel fakeProfileModel = ProfileModel.fromJson(fakeDataJson);

  group("Profile Remote Data Source", () {
    group("getUser()", () {
      test('BERHASIL', () async {
        // stub -> kondisi untuk kita palsukan
        // proses stubbing
        when(remoteDataSource.getUser(userId))
            .thenAnswer((_) async => fakeProfileModel);

        try {
          var response = await remoteDataSource.getUser(userId);
          expect(response, fakeProfileModel);
        } catch (e) {
          fail("Tidak mungkin terjadi");
        }
      });

      test('GAGAL', () async {
        // stub -> kondisi untuk kita palsukan
        // proses stubbing
        when(remoteDataSource.getUser(userId)).thenThrow(Exception());

        try {
          await remoteDataSource.getUser(userId);
          fail("Tidak mungkin terjadi");
        } catch (e) {
          expect(e, isException);
        }
      });
    });

    group("getAllUser()", () {
      test('BERHASIL', () async {
        // stub -> kondisi untuk kita palsukan
        // proses stubbing
        when(remoteDataSource.getAllUser(page))
            .thenAnswer((_) async => [fakeProfileModel]);

        try {
          var response = await remoteDataSource.getAllUser(page);
          expect(response, [fakeProfileModel]);
        } catch (e) {
          fail("Tidak mungkin terjadi");
        }
      });

      test('GAGAL', () async {
        // stub -> kondisi untuk kita palsukan
        // proses stubbing
        when(remoteDataSource.getAllUser(page)).thenThrow(Exception());

        try {
          await remoteDataSource.getAllUser(page);
          fail("Tidak mungkin terjadi");
        } catch (e) {
          expect(e, isException);
        }
      });
    });
  });

  group("Profile Remote Data Source Imoplementation", () {
    group("getUser()", () {
      test('BERHASIL (200)', () async {
        // stub -> kondisi untuk kita palsukan
        // proses stubbing
        when(mockClient.get(urlGetUser)).thenAnswer((_) async => http.Response(
            jsonEncode({
              "data": fakeDataJson,
            }),
            200));

        try {
          var response = await remoteDataSourceImplementation.getUser(userId);
          expect(response, fakeProfileModel);
        } catch (e) {
          fail("Tidak mungkin terjadi");
        }
      });

      test('GAGAL (404)', () async {
        when(mockClient.get(urlGetUser))
            .thenAnswer((_) async => http.Response(jsonEncode({}), 404));

        try {
          await remoteDataSourceImplementation.getUser(userId);
          fail("Tidak mungkin terjadi");
        } on EmptyException catch (e) {
          expect(e, isException);
        } catch (e) {
          expect(e, const EmptyException(message: "data not found - 404"));
        }
      });

      test('GAGAL (500)', () async {
        when(mockClient.get(urlGetUser))
            .thenAnswer((_) async => http.Response(jsonEncode({}), 500));

        try {
          await remoteDataSourceImplementation.getUser(userId);
          fail("Tidak mungkin terjadi");
        } on EmptyException {
          fail("Tidak mungkin terjadi");
        } catch (e) {
          expect(e, isException);
        }
      });
    });

    group("getAllUser()", () {
      test('BERHASIL (200)', () async {
        // stub -> kondisi untuk kita palsukan
        // proses stubbing
        when(mockClient.get(urlGetAllUser))
            .thenAnswer((_) async => http.Response(
                jsonEncode({
                  "data": [fakeDataJson],
                }),
                200));

        try {
          var response = await remoteDataSourceImplementation.getAllUser(page);
          expect(response, [fakeProfileModel]);
        } on EmptyException {
          fail("Tidak mungkin terjadi");
        } on StatusCodeException {
          fail("Tidak mungkin terjadi");
        } catch (e) {
          fail("Tidak mungkin terjadi");
        }
      });

      test('GAGAL (EMPTY)', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
            (_) async => http.Response(jsonEncode({"data": []}), 200));

        try {
          await remoteDataSourceImplementation.getAllUser(page);
          fail("Tidak mungkin terjadi");
        } on EmptyException catch (e) {
          expect(e, isException);
        } on StatusCodeException {
          fail("Tidak mungkin terjadi");
        } catch (e) {
          fail("Tidak mungkin terjadi");
        }
      });

      test('GAGAL (404)', () async {
        when(mockClient.get(urlGetAllUser))
            .thenAnswer((_) async => http.Response(jsonEncode({}), 404));

        try {
          await remoteDataSourceImplementation.getAllUser(page);
          fail("Tidak mungkin terjadi");
        } on EmptyException {
          fail("Tidak mungkin terjadi");
        } on StatusCodeException catch (e) {
          expect(e, isException);
        } catch (e) {
          fail("Tidak mungkin terjadi");
        }
      });

      test('GAGAL (500)', () async {
        when(mockClient.get(urlGetAllUser))
            .thenAnswer((_) async => http.Response(jsonEncode({}), 500));

        try {
          await remoteDataSourceImplementation.getAllUser(page);
          fail("Tidak mungkin terjadi");
        } on EmptyException {
          fail("Tidak mungkin terjadi");
        } on StatusCodeException {
          fail("Tidak mungkin terjadi");
        } catch (e) {
          expect(e, isException);
        }
      });
    });
  });
}
