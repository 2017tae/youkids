// import 'dart:io';  // 통신 용도
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImgWidget extends StatefulWidget {
  final Function(List<String>) onUploadedImgsPath;
  const UploadImgWidget({
    super.key,
    required this.onUploadedImgsPath,
  });

  @override
  State<UploadImgWidget> createState() => _UploadImgWidgetState();
}

class _UploadImgWidgetState extends State<UploadImgWidget> {
  final ImagePicker _picker = ImagePicker(); // ImagePicker 초기화
  List<XFile> _selectedImgs = []; // 이미지를 담을 리스트

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
    return Row(
      children: [
        GestureDetector(
          onTap: selectImg,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: const Color(0xff929292).withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.add_a_photo_outlined,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8 - 50,
          height: MediaQuery.of(context).size.width * 0.2,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    width:
                        MediaQuery.of(context).size.width * 0.2, // 아이템의 너비 설정
                    height:
                        MediaQuery.of(context).size.width * 0.2, // 아이템의 높이 설정
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.file(
                      File(
                        _selectedImgs[index].path,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => deleteImg(idx: index),
                      icon: const Icon(
                        Icons.close_sharp,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            itemCount: _selectedImgs.length,
          ),
        ),
      ],
    );
  }
}
