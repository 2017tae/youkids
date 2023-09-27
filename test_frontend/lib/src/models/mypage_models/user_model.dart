class UserModel {
  String userId, nickname;
  String? profileImage, description;

  UserModel(
      {required this.userId,
      required this.nickname,
      this.profileImage,
      this.description});

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        nickname = json['nickname'],
        profileImage = json['profileImage'],
        description = json['description'];
}
