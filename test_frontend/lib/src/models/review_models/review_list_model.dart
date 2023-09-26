class ReviewListModel {
  final int id;
  final double rating;
  final String date, content;

  ReviewListModel({
    required this.id,
    required this.rating,
    required this.date,
    required this.content,
  });
}

List<ReviewListModel> userReviewList = [
  ReviewListModel(
    id: 1,
    rating: 3.5,
    date: '2023.09.13',
    content: '맛있게 먹었어요 맛은 그냥 쏘쏘~',
  ),
  ReviewListModel(
    id: 2,
    rating: 4.5,
    date: '2023.09.01',
    content: '굿굿 아이도 좋아하네요',
  ),
  ReviewListModel(
    id: 3,
    rating: 4.5,
    date: '2023.08.23',
    content: '맛있음',
  ),
  ReviewListModel(
    id: 4,
    rating: 0.5,
    date: '2023.08.11',
    content: '최악이에요 가지 마세요',
  ),
];
