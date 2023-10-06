import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/course/course_create_screen.dart';
import 'package:youkids/src/screens/shop/shop_detail_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/models/course_models/course_detail_model.dart';
import 'package:youkids/src/providers/course_providers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  bool _isLoggedIn = false;
  NaverMapController? _controller;
  String? selectedMarkerId;
  late ScrollController scrollController;
  List<Course_detail_model> courses = [];
  List? bookmarks;
  List<NMarker> coursePlaces = [];
  bool isMaxHeightReached = false;
  double latitude = 37.5;
  double longitude = 127.0;
  double zoomLevel = 15.0;
  bool isLoading = true;
  bool isLoadingCurCoords = true;
  bool isCourseList = true;
  bool isCurCoords = false;
  NMarker? curMarker;
  String? userId;
  Future? loadDataFuture;
  CourseProviders courseProviders = CourseProviders();

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    );
  }

  void toggleButtonText() {
    setState(() {
      isCourseList = !isCourseList;
    });

    // 네이버 지도 생성 후
    if (_controller != null) {
      // 현재 생성되어있는 좌표 일괄 삭제
      _controller!.clearOverlays();

      // 만약 현재 위치를 불러온 적이 있으면
      if (isCurCoords) {
        //현재 좌표 렌더링
        _controller!.addOverlay(curMarker!);
      }

      // 만약 찜 목록이라면
      if (!isCourseList && bookmarks!.length == 1) {
        _controller!.updateCamera(
          NCameraUpdate.fromCameraPosition(
            NCameraPosition(
              target: NLatLng(
                  bookmarks![0]['latitude'], bookmarks![0]['longitude']),
              zoom: 13.5,
            ),
          )..setPivot(NPoint(0.5, 1 / 4)),
        );
        final marker = NMarker(
          icon:
              NOverlayImage.fromAssetImage("lib/src/assets/icons/mapMark.png"),
          size: NMarker.autoSize,
          id: "1000",
          position:
              NLatLng(bookmarks![0]['latitude'], bookmarks![0]['longitude']),
        );
        // 마커 지도 위에 렌더링
        _controller!.addOverlay(marker);
      }
      if (!isCourseList && bookmarks!.length > 1) {
        List<NLatLng> bound = [];
        //모든 찜 목록의 좌표를 bound에 넣음
        for (var place in bookmarks!) {
          bound.add(NLatLng(place['latitude'], place['longitude']));
        }

        // 좌표가 나올 화면
        var bounds = NLatLngBounds.from(bound);

        // 화면을 북마크가 전부 보이게 업데이트
        _controller!.updateCamera(
          NCameraUpdate.fitBounds(bounds, padding: EdgeInsets.all(80)),
        );
        int i = 100;
        for (var place in bookmarks!) {
          final marker = NMarker(
            icon: NOverlayImage.fromAssetImage(
                "lib/src/assets/icons/mapMark.png"),
            size: NMarker.autoSize,
            id: i.toString(),
            position: NLatLng(place['latitude'], place['longitude']),
          );

          marker.setOnTapListener((NMarker marker) {
            var cameraUpdate = NCameraUpdate.fromCameraPosition(
              NCameraPosition(
                target: NLatLng(
                    marker.position.latitude, marker.position.longitude),
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
                    final matchingBookmark = bookmarks!.firstWhere(
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
                                horizontal: 20, vertical: 15), // 좌우 패딩 값 설정
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  // 위아래로 배치
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
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          ShopDetailScreen(
                                              placeId:
                                                  matchingBookmark?['placeId']),
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
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          ShopDetailScreen(
                                              placeId:
                                                  matchingBookmark?['placeId']),
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
          _controller!.addOverlay(marker);
        }
      }
    }
  }

  Future initCourses() async {
    String api = dotenv.get("api_key");
    courses =
        await courseProviders.getCourse(Uri.parse(api + "/course/" + userId!));
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
    print(bookmarks);
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
          isCurCoords = true;
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

  Future<void> _checkLoginStatus() async {
    userId = await getUserId();
    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });

    if (userId != null) {
      await initCourses();
      await initBookmark();
    }
    print(courses);
  }

  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
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
        curMarker = NMarker(
            icon:
                NOverlayImage.fromAssetImage("lib/src/assets/icons/myMark.png"),
            size: NMarker.autoSize,
            id: "curCoord",
            position: NLatLng(latitude, longitude));
        _controller!.addOverlay(curMarker!);
      }
    }
  }

  Future<bool> _deleteConfirmDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제'),
          content: Text('해당 코스를 삭제합니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDeleteCourse(Course_detail_model course) async {
    String api = dotenv.get("api_key");
    Uri uri = Uri.parse(api + "/course");

    Map data = {"courseId": course.courseId, "userId": userId};

    var body = json.encode(data);

    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        courses.remove(course);
      });
    }
  }

  Future<void> _startNavigation(Course_detail_model course) async {
    if (await NaviApi.instance.isKakaoNaviInstalled()) {
      List<Location> viaList = [];

      // 경유지 추가
      for (var place in course.places) {
        viaList.add(Location(
          name: place.name,
          x: place.longitude.toString(),
          y: place.latitude.toString(),
        ));
      }
      print(viaList.toString());
      // 카카오내비로 경로 안내 연결
      await NaviApi.instance.shareDestination(
        // 마지막 경유지가 목적지
        destination: viaList.last,

        // 첫번째 ~ 마지막-1번째 까지 경유지
        viaList: viaList.sublist(0, viaList.length - 1),

        // wgs84 좌표계 옵션
        option: NaviOption(coordType: CoordType.wgs84),
      );
    } else {
      //카카오내비가 없는 경우

      // 카카오내비 설치 페이지 이동
      launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
    }
  }

  void _onCourseClicked(Course_detail_model course) {
    // Naver map contorller 불러오기
    if (_controller != null) {
      _controller!.clearOverlays();
      List<NLatLng> bound = [];

      for (var place in course.places) {
        bound.add(NLatLng(place.latitude, place.longitude));
      }

      var bounds = NLatLngBounds.from(bound);

      _controller!.updateCamera(
        NCameraUpdate.fitBounds(bounds,
            padding:
                EdgeInsets.only(bottom: 150, top: 250, right: 50, left: 50))
          ..setPivot(NPoint(0.5, 1 / 4)),
      );

      /*
       * 해당 코스 마커 렌더링
       * 첫번째 마커부터 1~n
       *
       */
      int i = 1;
      for (var place in course.places) {
        final marker = NMarker(
          icon: NOverlayImage.fromAssetImage(
              "lib/src/assets/icons/mark" + place.order.toString() + ".png"),
          size: NMarker.autoSize,
          id: i.toString(),
          position: NLatLng(place.latitude, place.longitude),
        );
        i++;

        // 마커 지도 위에 렌더링
        _controller!.addOverlay(marker);
      }
    }
  }

  void _onBookmarkClicked(double x, double y) {
    if (_controller != null) {
      _controller!.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(x, y),
            zoom: 11.5,
          ),
        )..setPivot(NPoint(0.5, 1 / 4)),
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
              padding: const EdgeInsets.only(right: 10.0, top: 0, bottom: 0),
              child: TextButton(
                onPressed: () {
                  if (userId != null) {
                    if (bookmarks != null && bookmarks!.isNotEmpty) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              CourseCreateScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("알림"),
                            content: Text("찜 목록이 비었습니다."),
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("로그인"),
                          content: Text("로그인을 해주세요"),
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
            onMapReady: (controller) {
              setState(() {
                _controller = controller; // NaverMapController 초기화
              });
            },
          ),
          //상단 찜, 코스 목록 토글 버튼
          Positioned(
            top: 10,
            left: (MediaQuery.of(context).size.width - 80) / 2,
            height: 25,
            child: ElevatedButton(
              onPressed: () async {
                toggleButtonText();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFF6766E),
                backgroundColor: Color(0xFFF6766E),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                fixedSize: Size(80, 25),
              ),
              child: Text(
                isCourseList ? '코스 목록' : '찜 목록',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                            if (!isCourseList && userId != null)
                              if (bookmarks == null || bookmarks!.isEmpty)
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                    child: Text(
                                      '불러올 찜 목록이 없습니다',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                            if (!isCourseList &&
                                bookmarks != null &&
                                bookmarks!.isNotEmpty)
                              ...(bookmarks ?? []).map((bookmark) {
                                return GestureDetector(
                                  onTap: () => {
                                    _onBookmarkClicked(
                                        bookmark['latitude'] ?? 36,
                                        bookmark['longitude'] ?? 127)
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  bookmark?['name'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                  overflow:
                                                  TextOverflow.ellipsis,
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
                                                          bookmark?[
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
                            if (isCourseList && userId != null)
                              if (isCourseList && courses.isEmpty)
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                    child: Text(
                                      '불러올 코스 목록이 없습니다',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                            if (isCourseList && courses.isNotEmpty)
                              ...courses.asMap().entries.map((entry) {
                                final course = entry.value;
                                return GestureDetector(
                                  onTap: () => _onCourseClicked(course),
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Slidable(
                                          endActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            extentRatio: 0.15,
                                            closeThreshold: 0.01,
                                            children: [
                                              SlidableAction(
                                                backgroundColor: Colors.red,
                                                padding: EdgeInsets.zero,
                                                spacing: 5.0,
                                                icon: Icons.delete,
                                                onPressed: (context) async {
                                                  bool confirmDelete =
                                                      await _deleteConfirmDialog(
                                                          context);
                                                  if (confirmDelete) {
                                                    _onDeleteCourse(course);
                                                  }
                                                },
                                              ),
                                            ],
                                            openThreshold: 0.001,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                        course.courseName,
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: TextButton(
                                                          onPressed: () async {
                                                            _startNavigation(
                                                                course);
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Color(
                                                                            0xFFF6766E)),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50.0),
                                                              ),
                                                            ),
                                                            padding:
                                                                MaterialStateProperty.all<
                                                                        EdgeInsetsGeometry>(
                                                                    EdgeInsets
                                                                        .zero),
                                                          ),
                                                          child:
                                                              SvgPicture.asset(
                                                            'lib/src/assets/icons/navi.svg',
                                                            width: 24,
                                                            height: 24,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '경로 안내',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 10,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...course.places
                                            .asMap()
                                            .entries
                                            .map((placeEntry) {
                                          final placeIndex = placeEntry.key;
                                          final place = placeEntry.value;
                                          return Column(
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
                                                          (place.order)
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
                                                        SizedBox(height: 20.0),
                                                        Text(
                                                          place.name,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                          place.address,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(height: 20.0)
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Divider(
                                                  color: Color(0xFF949494),
                                                  thickness: placeIndex ==
                                                          course.places.length -
                                                              1
                                                      ? 1.5
                                                      : 0.5,
                                                  height: placeIndex ==
                                                          course.places.length -
                                                              1
                                                      ? 50.0
                                                      : 0.0,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
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
                                  isCourseList ? '코스 목록' : '찜 목록',
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
