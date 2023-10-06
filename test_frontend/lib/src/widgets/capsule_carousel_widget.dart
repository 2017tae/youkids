import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CapsuleCarouselWidget extends StatefulWidget {
  final List<String> imgUrls;
  const CapsuleCarouselWidget({
    super.key,
    required this.imgUrls,
  });

  @override
  State<CapsuleCarouselWidget> createState() => _CapsuleCarouselWidgetState();
}

class _CapsuleCarouselWidgetState extends State<CapsuleCarouselWidget> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.imgUrls
        .map(
          (item) => Image.network(item,
              fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
        )
        .toList();
    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.width,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.imgUrls.asMap().entries.map(
              (entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 15.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffFF7E76)
                          .withOpacity(_current == entry.key ? 1 : 0.3),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
