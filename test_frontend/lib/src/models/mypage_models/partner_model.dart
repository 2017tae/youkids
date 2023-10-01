class PartnerModel {
  String partnerId, partnerEmail;
  String? nickname, profileImage;

  PartnerModel(
      {required this.partnerId,
      required this.partnerEmail,
      this.nickname,
      this.profileImage});

  PartnerModel.fromJson(Map<String, dynamic> json)
      : partnerId = json['partnerId'],
        partnerEmail = json['partnerEmail'],
        nickname = json['nickname'],
        profileImage = json['profileImage'];
}
