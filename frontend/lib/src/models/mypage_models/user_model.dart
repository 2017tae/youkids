class UserModel {
  String userId, nickname;
  String? profileImage;

  UserModel({required this.userId, required this.nickname, this.profileImage});

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        nickname = json['nickname'],
        profileImage = json['profileImage'] ?? 'no image';
}
