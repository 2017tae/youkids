class MyinfoModel {
  final String email, nickname;
  final bool leader, car;
  final String? description, profileImage;

  MyinfoModel(
      {required this.email,
      required this.nickname,
      required this.leader,
      this.description,
      this.profileImage,
      required this.car});

  MyinfoModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        nickname = json['nickname'],
        leader = json['leader'],
        profileImage = json['profileImage'],
        description = json['description'],
        car = json['car'];
}
