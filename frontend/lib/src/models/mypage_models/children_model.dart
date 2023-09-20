class ChildrenModel {
  final int childrenId, gender;
  final String parentId, name, birthday;
  final String? childrenImage;

  ChildrenModel(
      {required this.childrenId,
      required this.parentId,
      required this.name,
      required this.gender,
      required this.birthday,
      this.childrenImage});

  ChildrenModel.fromJson(Map<String, dynamic> json)
      : childrenId = json['childrenId'],
        parentId = json['parentId'],
        name = json['name'],
        gender = json['gender'],
        birthday = json['birthday'],
        childrenImage = json['childrenImage'];
}
