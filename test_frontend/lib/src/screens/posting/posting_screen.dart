import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/services/posting_services.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/widgets/posting_content_widget.dart';
import 'package:youkids/src/widgets/posting_imgs_widget.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  String? userId;
  Future? loadDataFuture;
  bool _isLoggedIn = false;

  String _postingContent = ''; // 내용 담기는 변수
  String _postingLocation = ''; // 위치 담기는 변수
  List<String> _postingImgs = []; // 사진
  final List<List<int>> _childrenList = []; // 사진에 담길 아이 태그
  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    ); // Returns 'john_doe' if it exists, otherwise returns null.
  }

  Future<void> _checkLoginStatus() async {
    userId = await getUserId();

    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });
  }

  void _updatePostingContent(String content) {
    setState(() {
      _postingContent = content;
    });
  }

  void _updatePostingLocation(String location) {
    setState(() {
      _postingLocation = location;
    });
  }

  void _updatePostingImgs(List<String> imagePaths) {
    setState(() {
      _postingImgs = imagePaths;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YouKids',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_postingContent.isEmpty || _postingLocation.isEmpty) {
                // _postingContent나 _postingLocation 중 하나라도 비어 있다면 아무 작업도 수행하지 않음
                return;
              } else {
                PostingServices.postingCapsuleImgsContents(
                  description: _postingContent,
                  fileList: _postingImgs,
                  childrenList: _childrenList,
                  location: _postingLocation,
                  userId: userId,
                );
              }
            },
            icon: const Icon(
              Icons.create_outlined,
              color: Color(0xffF6766E),
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            PostingImgsWidget(onUploadedImgsPath: _updatePostingImgs),
            PostingContentWidget(
              onPostContentChanged: _updatePostingContent,
              onPostLocationChanged: _updatePostingLocation,
            ),
          ],
        ),
      )),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 2,
      ),
    );
  }
}
