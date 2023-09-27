class MyinfoModel {
  final String email, nickname;
  final bool leader;
  final String? description, profileImage;

  MyinfoModel(
      {required this.email,
      required this.nickname,
      required this.leader,
      this.description,
      this.profileImage});

  MyinfoModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        nickname = json['nickname'],
        leader = json['leader'],
        description = json['description'],
        profileImage = json['profileImage'];
}
