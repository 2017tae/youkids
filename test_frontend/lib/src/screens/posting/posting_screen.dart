import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/capsule/capsule_screen.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
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
    setState(() {});
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
              if (_postingContent.trim().isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('내용을 입력해 주세요'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
              } else if (_postingLocation.trim().isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('장소를 입력해 주세요'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
              } else if (_postingImgs.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('사진을 넣어주세요'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
              }
              else {
                try {
                  PostingServices.postingCapsuleImgsContents(
                    description: _postingContent,
                    fileList: _postingImgs,
                    childrenList: _childrenList,
                    location: _postingLocation,
                    userId: userId,
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CapsuleScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.green[400],
                            size: 30,
                          ),
                        ),
                      );
                    },
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text('다시 시도해 주십시오'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                }
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
        ),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 2,
      ),
    );
  }
}
