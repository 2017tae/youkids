class PartnerModel {
  String partnerId, nickname;
  String? profileImage;

  PartnerModel(
      {required this.partnerId, required this.nickname, this.profileImage});

  PartnerModel.fromJson(Map<String, dynamic> json)
      : partnerId = json['partnerId'],
        nickname = json['nickname'],
        profileImage = json['profileImage'] ?? 'no image';
}
