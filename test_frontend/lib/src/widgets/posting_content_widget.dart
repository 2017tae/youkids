import 'package:flutter/material.dart';

class PostingContentWidget extends StatefulWidget {
  final Function(String) onPostContentChanged;
  const PostingContentWidget({
    super.key,
    required this.onPostContentChanged,
  });

  @override
  State<PostingContentWidget> createState() => _PostingContentWidgetState();
}

class _PostingContentWidgetState extends State<PostingContentWidget> {
  TextEditingController contentController = TextEditingController();
  String postingContent = ''; // onChange 변수

  @override
  void dispose() {
    // TODO: implement dispose
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: contentController,
          decoration: const InputDecoration(
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
          maxLines: 7,
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
