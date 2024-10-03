import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  final String firstName;
  final String lastName;
  final String avatar;

  const ProfileModel(
      {required super.id,
      required super.email,
      required this.firstName,
      required this.lastName,
      required this.avatar})
      : super(fullName: "$firstName $lastName", profileImageUrl: avatar);

  // Map -> ProfileModel
  factory ProfileModel.fromJson(Map<String, dynamic> data) {
    // Map<String, dynamic> data = dataJson["data"];
    return ProfileModel(
      id: data["id"],
      email: data["email"],
      firstName: data["first_name"],
      lastName: data["last_name"],
      avatar: data["avatar"],
    );
  }

  // ProfileModel -> Map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "avatar": avatar
    };
  }

  // List<Map> -> List<ProfileModel>
  static List<ProfileModel> fromJsonList(List data) {
    if (data.isEmpty) return [];

    // opsi 1 (for loop)
    // List<ProfileModel> allData = [];
    // for (var i = 0; i < data.length; i++) {
    //   Map<String, dynamic> singleDataProfile = data[i];
    //   allData.add(ProfileModel.fromJson(singleDataProfile));
    // }

    // return allData;

    // opsi 2 (.map())
    return data.map((e) => ProfileModel.fromJson(e)).toList();
  }
}
