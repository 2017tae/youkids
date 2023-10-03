import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/course/course_post_screen.dart';
import 'package:youkids/src/screens/shop/shop_detail_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/providers/course_providers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CourseCreateScreen extends StatefulWidget {
  const CourseCreateScreen({super.key});

  @override
  _CourseCreateScreenState createState() => _CourseCreateScreenState();
}

class _CourseCreateScreenState extends State<CourseCreateScreen> {
  NaverMapController? _controller;
  String? selectedMarkerId;
  late ScrollController scrollController;
  List? bookmarks;

  // 코스에 넣을 장소 리스트
  List<NMarker> coursePlaces = [];
  bool isMaxHeightReached = false;
  double latitude = 37.5;
  double longitude = 127.0;
  double zoomLevel = 15.0;
  bool isLoading = true;
  bool isLoadingCurCoords = true;
  String? userId = "87dad60a-bfff-47e5-8e21-02cb49b23ba6";
  CourseProviders courseProviders = CourseProviders();

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    );
  }

  Future initBookmark() async {
    String api = dotenv.get("api_key2");
    final response = await http.get(Uri.parse(api + '/' + userId!));
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      setState(() {
        bookmarks = decodedJson['result']['bookmarks'];
      });
    }
  }

  Future addPlace(NMarker marker) async {
    setState(() {
      coursePlaces.add(marker);
    });
    marker.setIcon(NOverlayImage.fromAssetImage("lib/src/assets/icons/mark" +
        (coursePlaces.length).toString() +
        ".png"));
  }

  Future removePlace(NMarker marker) async {
    setState(() {
      coursePlaces.remove(marker);
    });
    marker.setIcon(
        NOverlayImage.fromAssetImage("lib/src/assets/icons/mapMark.png"));
    int i = 1;
    for (var place in coursePlaces) {
      place.setIcon(NOverlayImage.fromAssetImage(
          "lib/src/assets/icons/mark" + i.toString() + ".png"));
      i++;
    }
  }

  void _onMapReady(NaverMapController controller) {
    setState(() {
      _controller = controller;
      _initData();
    });
  }

  Future _renderBookmark(List? bookmarks) async {
    if (bookmarks != null) {
      print(bookmarks);
      List<NLatLng> bound = [];
      for (var place in bookmarks) {
        bound.add(NLatLng(place['latitude'], place['longitude']));
      }

      var bounds = NLatLngBounds.from(bound);
      print(bounds);
      if (_controller == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("오류"),
              content: Text("찜 목록을 불러오는 데 오류가 발생했습니다"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("닫기"),
                ),
              ],
            );
          },
        );
      }
      _controller!.updateCamera(
        NCameraUpdate.fitBounds(bounds, padding: EdgeInsets.all(50)),
      );
      // 해당 코스 마커 렌더링
      int i = 0;
      for (var place in bookmarks) {
        final marker = NMarker(
          icon:
          NOverlayImage.fromAssetImage("lib/src/assets/icons/mapMark.png"),
          size: NMarker.autoSize,
          id: i.toString(),
          position: NLatLng(place['latitude'], place['longitude']),
        );

        marker.setOnTapListener((NMarker marker) {
          var cameraUpdate = NCameraUpdate.fromCameraPosition(
            NCameraPosition(
              target:
              NLatLng(marker.position.latitude, marker.position.longitude),
              zoom: 10,
            ),
          )..setPivot(NPoint(0.5, 1 / 4));

          cameraUpdate.setAnimation(
              animation: NCameraAnimation.fly, duration: Duration(seconds: 2));

          _controller!.updateCamera(cameraUpdate);

          showModalBottomSheet(
            barrierColor: Colors.transparent,
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  final matchingBookmark = bookmarks?.firstWhere(
                        (bookmark) =>
                    bookmark['latitude'] == marker.position.latitude &&
                        bookmark['longitude'] == marker.position.longitude,
                    orElse: () => null,
                  );
                  return Container(
                    height: 500,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (coursePlaces.contains(marker)) {
                                  removePlace(marker);
                                } else if (coursePlaces.length < 5) {
                                  addPlace(marker);
                                } else if (coursePlaces.length >= 5) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("오류"),
                                        content: Text("장소는 최대 5개까지 선택 가능합니다."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("닫기"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                setState(() {});
                              },
                              child: Text(
                                  coursePlaces.contains(marker) ? '제거' : '추가'),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) =>
                                    ShopDetailScreen(placeId: matchingBookmark?['placeId']),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          matchingBookmark?['name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'lib/src/assets/icons/course_white.svg',
                                                height: 16,
                                              ),
                                              SizedBox(width: 5.0),
                                              Flexible(
                                                child: Text(
                                                  matchingBookmark?[
                                                  'address'] ??
                                                      '',
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Color(0xFF949494),
                                    thickness: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        });
        i++;

        // 마커 지도 위에 렌더링
        await _controller!.addOverlay(marker);
      }
    }
  }


  Future<void> getCurrentLocation() async {
    // 위치 권한 받음
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((response) {
        setState(() {
          latitude = response.latitude;
          longitude = response.longitude;
          isLoadingCurCoords = false;
        });
      });
      _updateCamera();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initCurrentLocation() async {
    await getCurrentLocation();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initData() async {
    await initBookmark(); // initBookmark 메서드 완료 대기
    setState(() {
      isLoading = false;
      _renderBookmark(bookmarks);
    });
  }

  @override
  void initState() {
    super.initState();
    // getUserId().then((userId) {
    //   if (userId != null) {
    // }
    // });
    // _initCurrentLocation();
    scrollController = ScrollController();
    scrollController.addListener(() {
      // maxheight에 도달했으면
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          isMaxHeightReached = true;
        });
      } else {
        setState(() {
          isMaxHeightReached = false;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _updateCamera() async {
    final cameraPosition = await _controller!.getCameraPosition();

    final currentZoom = cameraPosition.zoom;

    _controller!.updateCamera(
      NCameraUpdate.fromCameraPosition(NCameraPosition(
        target: NLatLng(latitude - pow(1 / 1.55, currentZoom), longitude),
        zoom: currentZoom,
      )),
    );
  }

  Future<void> _findMyCoords() async {
    await _initCurrentLocation();
    if (!isLoadingCurCoords) {
      if (_controller != null) {
        _updateCamera();
        final marker = NMarker(
            icon: NOverlayImage.fromAssetImage(
                "lib/src/assets/icons/mapMark.png"),
            size: NMarker.autoSize,
            id: "curCoord",
            position: NLatLng(latitude, longitude));
        _controller!.addOverlay(marker);
      }
    }
  }

  void _onBookmarkClicked(double x, double y) {
    if (_controller != null) {
      // for (int i = 0; i < coursePlaces.length; i++) {
      //   _controller!.deleteOverlay(
      //       NOverlayInfo(type: NOverlayType.marker, id: i.toString()));
      // }
      _controller!.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(x - 0.2, y),
            zoom: 8.5,
          ),
        ),
      );

      // 해당 코스 마커 렌더링
      int i = 0;
      final marker = NMarker(
        icon: NOverlayImage.fromAssetImage("lib/src/assets/icons/mapMark.png"),
        size: NMarker.autoSize,
        id: i.toString(),
        position: NLatLng(x, y),
      );

      // 마커 지도 위에 렌더링
      _controller!.addOverlay(marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
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
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      CoursePostScreen(coursePlaces: coursePlaces, bookmarks: bookmarks),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            icon: SvgPicture.asset('lib/src/assets/icons/add_white.svg',
                height: 24),
          ),
        ],
      ),
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(
                    37.5110317,
                    127.0602133,
                  ),
                  zoom: 15,
                ),
                locale: Locale.fromSubtags(languageCode: 'Ko')),
            onMapReady: _onMapReady,
          ),
          //상단 찜, 코스 목록 토글 버튼
          DraggableScrollableSheet(
            minChildSize: 0.06,
            maxChildSize: 0.5,
            initialChildSize: 0.06,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 70,
                            ),
                            if (userId == null)
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Center(
                                  child: Text(
                                    '로그인을 해주세요',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ...(coursePlaces ?? []).map((coursePlace) {
                              final matchingBookmark = bookmarks?.firstWhere(
                                (bookmark) =>
                                    bookmark['latitude'] ==
                                        coursePlace.position.latitude &&
                                    bookmark['longitude'] ==
                                        coursePlace.position.longitude,
                                orElse: () => null,
                              );

                              return GestureDetector(
                                onTap: () {
                                  if (matchingBookmark != null) {
                                    final name = matchingBookmark['name'];
                                    final address = matchingBookmark['address'];
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                matchingBookmark?['name'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'lib/src/assets/icons/course_white.svg',
                                                      height: 16,
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Flexible(
                                                      child: Text(
                                                        matchingBookmark?[
                                                                'address'] ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Divider(
                                          color: Color(0xFF949494),
                                          thickness: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          // boxShadow: [
                          //   BoxShadow(
                          //     blurRadius: 100
                          //   )
                          // ]
                        ),
                        child: Column(
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10, bottom: 5),
                                    height: 8,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              flex: 1,
                            ),
                            Flexible(
                                child: Text(
                                  '선택한 장소',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 1),
                          ],
                        ),
                        height: 65,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 1,
      ),
      floatingActionButton: Container(
        height: 45,
        width: 45,
        // margin: EdgeInsets.symmetric(vertical: 35),
        child: FloatingActionButton(
          onPressed: () async {
            _findMyCoords();
          },
          backgroundColor: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset('lib/src/assets/icons/coords.svg'),
        ),
      ),
    );
  }
}
