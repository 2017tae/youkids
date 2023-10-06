import 'package:flutter/material.dart';
import 'package:youkids/src/widgets/bookmark_button_widget.dart';

class DiagonalBannerPainter extends CustomPainter {
  final String rank;

  DiagonalBannerPainter({
    required this.rank,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 대각선 배너 그리기
    final Paint paint = Paint()..color = Color(0xffFF7E76);
    final Path path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(0, size.width)
      ..close();
    canvas.drawPath(path, paint);

    // 텍스트 그리기
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(text: rank, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10)); // 위치 조정
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RankingWidgetCardFrame11 extends StatelessWidget {
  final String imageUrl, name, address, rank;
  final dynamic userId;
  final int placeId;

  const RankingWidgetCardFrame11({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.rank,
    required this.userId,
    required this.placeId,
  });

  String getFirstTwoWords(String text) {
    List<String> words = text.split(' ');
    if (words.length >= 2) {
      return '${words[0]} ${words[1]}';
    } else {
      return text; // 단어가 2개 미만이면 원래 문자열 반환
    }
  }

  // ... 기존 코드 ...

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 2 / 1,
              child: Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xffF5EEEC),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: (userId != null)
                  ? BookmarkButtonWidget(
                      placeId: placeId,
                      userId: userId,
                    )
                  : Container(),
            )
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          child: CustomPaint(
            painter: DiagonalBannerPainter(rank: rank),
            size: const Size(
              50,
              50,
            ), // 배너의 크기를 조정합니다.
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            child: (userId != null)
                ? BookmarkButtonWidget(
                    placeId: placeId,
                    userId: userId,
                  )
                : Container(),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5), // 더 큰 그림자 간격
                      blurRadius: 2.0, // 더 큰 블러 정도
                      color: Colors.black87, // 더 진한 그림자 색상
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              const SizedBox(
                width: 15,
              ), // 제목과 주소 사이 간격
              Text(
                getFirstTwoWords(address),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5), // 더 큰 그림자 간격
                      blurRadius: 2.0, // 더 큰 블러 정도
                      color: Colors.black87, // 더 진한 그림자 색상
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
