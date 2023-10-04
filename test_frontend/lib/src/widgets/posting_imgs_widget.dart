import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostingImgsWidget extends StatefulWidget {
  final Function(List<String>) onUploadedImgsPath;

  const PostingImgsWidget({
    super.key,
    required this.onUploadedImgsPath,
  });

  @override
  State<PostingImgsWidget> createState() => _PostingImgsWidgetState();
}

class _PostingImgsWidgetState extends State<PostingImgsWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImgs = [];

  void selectImg() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImgs = images;
        List<String> imagePaths =
            _selectedImgs.map((image) => image.path).toList();
        widget.onUploadedImgsPath(imagePaths); // 이미지 경로 리스트를 부모 위젯으로 전달
      });
    }
  }

  void deleteImg({required int idx}) async {
    setState(() {
      _selectedImgs.removeAt(idx);
      List<String> imagePaths =
          _selectedImgs.map((image) => image.path).toList();
      widget.onUploadedImgsPath(imagePaths); // 이미지 경로 리스트를 부모 위젯으로 전달
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
