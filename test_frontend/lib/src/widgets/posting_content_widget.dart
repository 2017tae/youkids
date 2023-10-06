import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostingContentWidget extends StatefulWidget {
  final Function(String) onPostContentChanged;
  final Function(String) onPostLocationChanged;
  const PostingContentWidget({
    super.key,
    required this.onPostContentChanged,
    required this.onPostLocationChanged,
  });

  @override
  State<PostingContentWidget> createState() => _PostingContentWidgetState();
}

class _PostingContentWidgetState extends State<PostingContentWidget> {
  TextEditingController contentController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String postingContent = ''; // onChange 변수

  @override
  void dispose() {
    // TODO: implement dispose
    contentController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: locationController,
          maxLength: 30, // 최대 글자 수
          inputFormatters: [LengthLimitingTextInputFormatter(30)],
          decoration: const InputDecoration(
            counterText: '',
            hintText: '어디를 다녀오셨나요?',
            hintStyle: TextStyle(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffF6766E),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffF6766E),
              ),
            ),
          ),
          onChanged: (location) {
            widget.onPostLocationChanged(location);
          },
          textInputAction: TextInputAction.done, // 완료 버튼 추가
          onEditingComplete: () {
            // 완료 버튼을 눌렀을 때 수행할 작업
            FocusScope.of(context).unfocus(); // 키보드를 내립니다.
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          maxLength: 240, // 최대 글자 수
          inputFormatters: [LengthLimitingTextInputFormatter(240)],
          controller: contentController,
          decoration: const InputDecoration(
            hintText: '내용을 입력하세요...',
            hintStyle: TextStyle(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffF6766E),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffF6766E),
              ),
            ),
          ),
          onChanged: (content) {
            widget.onPostContentChanged(content);
          },
          maxLines: 3,
          textInputAction: TextInputAction.done, // 완료 버튼 추가
          onEditingComplete: () {
            // 완료 버튼을 눌렀을 때 수행할 작업
            FocusScope.of(context).unfocus(); // 키보드를 내립니다.
          },
        ),
      ],
    );
  }
}
