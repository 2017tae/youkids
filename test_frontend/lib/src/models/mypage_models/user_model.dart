class UserModel {
  String userId;
  String? profileImage, description, nickname;

  UserModel(
      {required this.userId,
      this.nickname,
      this.profileImage,
      this.description});

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        nickname = json['nickname'],
        profileImage = json['profileImage'],
        description = json['description'];
}
