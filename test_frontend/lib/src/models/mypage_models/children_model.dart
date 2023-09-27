class ChildrenModel {
  final int childrenId, gender;
  final String name;
  final DateTime birthday;
  final String? childrenImage;

  ChildrenModel(
      {required this.childrenId,
      required this.name,
      required this.gender,
      required this.birthday,
      this.childrenImage});

  ChildrenModel.fromJson(Map<String, dynamic> json)
      : childrenId = json['childrenId'],
        name = json['name'],
        gender = json['gender'],
        birthday = DateTime.parse(json['birthday']),
        childrenImage = json['childrenImage'];
}
