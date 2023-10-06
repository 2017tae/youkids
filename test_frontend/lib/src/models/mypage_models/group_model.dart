import 'package:youkids/src/models/mypage_models/user_model.dart';

class GroupModel {
  String groupId, leaderId, groupName;
  String? groupImg;
  List<UserModel> groupMember;

  GroupModel(
      {required this.groupId,
      required this.leaderId,
      required this.groupName,
      this.groupImg,
      required this.groupMember});

  GroupModel.fromJson(Map<String, dynamic> json)
      : groupId = json['groupId'],
        leaderId = json['leaderId'],
        groupName = json['groupName'],
        groupImg = json['groupImg'],
        groupMember = [];
}
