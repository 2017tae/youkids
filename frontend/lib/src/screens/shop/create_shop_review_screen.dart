import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CreateShopReviewScreen extends StatefulWidget {
  const CreateShopReviewScreen({super.key});

  @override
  State<CreateShopReviewScreen> createState() => _CreateShopReviewScreenState();
}

class _CreateShopReviewScreenState extends State<CreateShopReviewScreen> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '리뷰',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              '등록',
              style: TextStyle(
                color: Color(0xffF6766E),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.2,
              color: const Color(0xffF5EEEC),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    '이글이글 불곱창(예시)',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  RatingBar(
                    minRating: 0.5,
                    maxRating: 5,
                    itemCount: 5,
                    itemSize: 40,
                    initialRating: 0,
                    allowHalfRating: true,
                    updateOnDrag: true,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                    ratingWidget: RatingWidget(
                      full: Image.asset(
                          'lib/src/assets/icons/rating_full_lg.png'),
                      half: Image.asset(
                          'lib/src/assets/icons/rating_half_lg.png'),
                      empty: Image.asset(
                          'lib/src/assets/icons/rating_empty_lg.png'),
                    ),
                    onRatingUpdate: (value) {
                      setState(() {
                        _currentRating = value;
                      });
                    },
                  ),
                  Text('별점$_currentRating'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    maxLength: 140,
                    maxLines: null, // 자동으로 줄 바꿈을 허용
                    decoration: const InputDecoration(
                      hintText: '리뷰를 입력해 주세요',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffF6766E),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffF6766E),
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.done, // 완료 버튼 추가
                    onEditingComplete: () {
                      // 완료 버튼을 눌렀을 때 수행할 작업
                      FocusScope.of(context).unfocus(); // 키보드를 내립니다.
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
