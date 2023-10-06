class PartnerModel {
  String partnerId, partnerEmail;
  String? nickname, profileImage, fcmToken;

  PartnerModel(
      {required this.partnerId,
      required this.partnerEmail,
      this.nickname,
      this.profileImage,
      this.fcmToken});

  PartnerModel.fromJson(Map<String, dynamic> json)
      : partnerId = json['partnerId'],
        partnerEmail = json['partnerEmail'],
        nickname = json['nickname'],
        profileImage = json['profileImage'],
        fcmToken = json['fcmToken'];
}
