class ReviewDetailModel {
  final int id;
  final double rating;
  final String date, content;

  ReviewDetailModel({
    required this.id,
    required this.rating,
    required this.date,
    required this.content,
  });
}

ReviewDetailModel user1ReviewDetail = ReviewDetailModel(
  id: 1,
  rating: 3.5,
  date: '2023.09.13',
  content: '맛있게 먹었어요 맛은 그냥 쏘쏘~',
);
