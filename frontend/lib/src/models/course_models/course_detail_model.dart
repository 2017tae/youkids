class Course_detail_model {
  late String courseId;
  late String courseName;
  late List<PlaceModel> places; // Define places as a list of PlaceModel

  Course_detail_model({
    required this.courseId,
    required this.courseName,
    required this.places,
  });

  Course_detail_model.fromMap(Map<String, dynamic>? map) {
    courseId = map?['courseId'] ?? '';
    courseName = map?['courseName'] ?? '';
    places = (map?['places'] as List<dynamic> ?? []).map((placeData) {
      return PlaceModel.fromMap(placeData);
    }).toList();
  }
}

class PlaceModel {
  late int placeId;
  late String name;
  late String address;
  late double latitude;
  late double longitude;
  late String category;
  late int order;

  PlaceModel({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.order,
  });

  PlaceModel.fromMap(Map<String, dynamic>? map) {
    placeId = map?['placeId'] ?? 0;
    name = map?['name'] ?? '';
    address = map?['address'] ?? '';
    latitude = map?['latitude'] ?? 0.0;
    longitude = map?['longitude'] ?? 0.0;
    category = map?['category'] ?? '';
    order = map?['order'] ?? 0;
  }
}
