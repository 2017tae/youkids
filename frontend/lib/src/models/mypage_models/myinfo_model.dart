class MyinfoModel {
  final String email, nickname;
  final String? profileImage;

  MyinfoModel({required this.email, required this.nickname, this.profileImage});

  MyinfoModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        nickname = json['nickname'],
        profileImage = json['profileImage'];
}
