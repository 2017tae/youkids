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
import 'package:youkids/src/providers/course_providers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CourseCreateScreen extends StatefulWidget {
  const CourseCreateScreen({super.key});

  @override
  _CourseCreateScreenState createState() => _CourseCreateScreenState();
}

class _CourseCreateScreenState extends State<CourseCreateScreen> {
  bool _isLoggedIn = false;
  NaverMapController? _controller;
  String? selectedMarkerId;
  late ScrollController scrollController;
  List? bookmarks;

  // 코스에 넣을 장소 리스트
  List<NMarker> coursePlaces = [];
  List<Map<String, dynamic>> coursePlacesInfo = [];
  bool isMaxHeightReached = false;
  double latitude = 37.5;
  double longitude = 127.0;
  double zoomLevel = 15.0;
  bool isLoading = true;
  bool isLoadingCurCoords = true;
  String? userId;
  Future? loadDataFuture;
  CourseProviders courseProviders = CourseProviders();

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    );
  }
  Future<void> _checkLoginStatus() async {
    userId = await getUserId();

    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });
  }

  Future initBookmark() async {
    String api = dotenv.get("api_key");
    final response =
        await http.get(Uri.parse(api + "/place/bookmark/" + userId!));
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      setState(() {
        bookmarks = decodedJson['result']['bookmarks'];
      });
    }
  }

  Future addPlace(NMarker marker, Map<String, dynamic> bookmark) async {
    setState(() {
      coursePlaces.add(marker);
      coursePlacesInfo.add(bookmark);
    });
    marker.setIcon(NOverlayImage.fromAssetImage("lib/src/assets/icons/mark" +
        (coursePlaces.length).toString() +
        ".png"));
  }

  Future removePlace(NMarker marker, Map<String, dynamic> bookmark) async {
    setState(() {
      coursePlaces.remove(marker);
      coursePlacesInfo.remove(bookmark);
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
      List<NLatLng> bound = [];
      for (var place in bookmarks) {
        bound.add(NLatLng(place['latitude'], place['longitude']));
      }

      var bounds = NLatLngBounds.from(bound);
      if (_controller == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("알림"),
              content: Text("찜 목록을 불러오는 데 실패하였습니다."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("확인"),
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
              animation: NCameraAnimation.linear,
              duration: Duration(seconds: 1));

          _controller!.updateCamera(cameraUpdate);

          showModalBottomSheet(
            barrierColor: Colors.transparent,
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  final matchingBookmark = bookmarks.firstWhere(
                    (bookmark) =>
                        bookmark['latitude'] == marker.position.latitude &&
                        bookmark['longitude'] == marker.position.longitude,
                    orElse: () => null,
                  );
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20), // 좌우 패딩 값 설정
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column( // 위아래로 배치
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    matchingBookmark?['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    matchingBookmark?['category'] ?? '',
                                    style: TextStyle(
                                      fontSize: 15,
                                      // fontWeight: FontWeight.w600,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: TextButton(
                                    onPressed: () async {
                                      if (coursePlaces.contains(marker)) {
                                        removePlace(marker, matchingBookmark);
                                      } else if (coursePlaces.length < 4) {
                                        addPlace(marker, matchingBookmark);
                                      } else if (coursePlaces.length >= 4) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("알림"),
                                              content: Text("장소는 최대 4개까지 선택 가능합니다."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("확인"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                      setState(() {});
                                    },
                                    style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                        BorderSide(
                                          color: Color(0xFFF6766E),
                                          width: 2.0,
                                        ),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all(Color(0xFFF6766E)),
                                    ),
                                    child: Text(
                                      coursePlaces.contains(marker) ? '제거' : '추가',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1,
                                        animation2) =>
                                    ShopDetailScreen(
                                        placeId: matchingBookmark?['placeId']),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: Image.network(
                            matchingBookmark['imageUrl'],
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1,
                                        animation2) =>
                                    ShopDetailScreen(
                                        placeId: matchingBookmark?['placeId']),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          "주소",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  matchingBookmark?[
                                                          'address'] ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
    await initBookmark();
    setState(() {
      isLoading = false;
      _renderBookmark(bookmarks);
    });
  }

  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
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
            icon:
                NOverlayImage.fromAssetImage("lib/src/assets/icons/myMark.png"),
            size: NMarker.autoSize,
            id: "curCoord",
            position: NLatLng(latitude, longitude));
        _controller!.addOverlay(marker);
      }
    }
  }

  void _onBookmarkClicked(double x, double y) {
    if (_controller != null) {
      _controller!.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(x - 0.2, y),
            zoom: 8.5,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          '코스',
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
          Container(
            height: 35,
            width: 65,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: TextButton(
                onPressed: () {
                  if(coursePlaces.isEmpty){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("알림"),
                          content: Text("코스로 선정된 장소가 없습니다."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("확인"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  if(coursePlaces.isNotEmpty) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            CoursePostScreen(
                              coursePlacesInfo: coursePlacesInfo,
                              coursePlaces: coursePlaces,
                            ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: Text(
                  '생성',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFF6766E)),
                ),
              ),
            ),
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
              locale: Locale.fromSubtags(languageCode: 'Ko'),
              contentPadding: EdgeInsets.only(bottom: 40),
            ),
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
                            ...coursePlaces.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final NMarker coursePlace = entry.value;
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
                                    _onBookmarkClicked(
                                        matchingBookmark['latitude'] ?? 36,
                                        matchingBookmark['longitude'] ?? 127);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0),
                                            child: Image.asset(
                                              "lib/src/assets/icons/mark" +
                                                  (index+1)
                                                      .toString() +
                                                  ".png",
                                              height: 35,
                                              alignment:
                                              AlignmentDirectional
                                                  .center,
                                            ),
                                          ),
                                          SizedBox(width: 12.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                SizedBox(height: 10.0),
                                                Text(
                                                  matchingBookmark['name'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                                Text(
                                                  matchingBookmark['address'],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors
                                                        .grey[700],
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                                SizedBox(height: 10.0)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                        EdgeInsets.symmetric(horizontal: 10),
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
