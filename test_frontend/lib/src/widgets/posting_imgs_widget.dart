import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
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
  int _current = 0;
  final CarouselController _controller = CarouselController();
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

  void deleteImg({
    required int idx,
  }) async {
    setState(() {
      _selectedImgs.removeAt(idx);
      List<String> imagePaths =
          _selectedImgs.map((image) => image.path).toList();
      widget.onUploadedImgsPath(imagePaths); // 이미지 경로 리스트를 부모 위젯으로 전달
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = _selectedImgs
        .map(
          (item) => Image.file(
            File(item.path),
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width,
          ),
        )
        .toList();
    return _selectedImgs.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: GestureDetector(
              onTap: selectImg,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFA49E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      "lib/src/assets/icons/camera.png",
                      width: 140,
                    ),
                  )
                ],
              ),
            ),
          )
        : Stack(
            children: [
              CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  height: MediaQuery.of(context).size.width,
                  viewportFraction: 0.7,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  onPressed: () => deleteImg(idx: _current),
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Color(0xffF6766E),
                  ),
                ),
              )
            ],
          );
  }
}
