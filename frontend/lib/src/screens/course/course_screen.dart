import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/models/course_models/course_detail_model.dart';
import 'package:youkids/src/providers/course_providers.dart';
import 'package:geolocator/geolocator.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  NaverMapController? _controller;
  late ScrollController scrollController;
  List<Course_detail_model> courses = [];
  bool isMaxHeightReached = false;
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLoading = true;
  CourseProviders courseProviders = CourseProviders();

  Future initCourses() async {
    String api = dotenv.get("api_key"); // Nullable 변수
    String userId = "";
    Uri uri = Uri.parse(api + userId);
    courses = await courseProviders.getCourse(uri);
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
        });
      });
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

  @override
  void initState() {
    super.initState();
    initCourses().then((_) {
      setState(() {
        isLoading = false;
      });
    });

    _initCurrentLocation();
    scrollController = ScrollController();
    scrollController.addListener(() {
      // Check if max height is reached
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
            onPressed: () {},
            icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
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
              locale: Locale('kr'),
            ),
            onMapReady: (controller) {
              setState(() {
                _controller = controller; // NaverMapController 초기화
              });
            },
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
                              height: 50,
                            ),
                            // Add your courses here
                            ...courses.map(
                              (course) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.courseName,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      ...course.places.map((place) => ListTile(
                                            title: Text(place.name),
                                            subtitle: Text(place.address),
                                          )),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 20),
                              height: 8,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
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
          ),
        ],
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller != null) {
            _controller!.updateCamera(
              NCameraUpdate.fromCameraPosition(NCameraPosition(
                target: NLatLng(latitude, longitude),
                zoom: 15.0,
              )),
            );
            final marker = NMarker(
                icon: NOverlayImage.fromAssetImage(
                    "lib/src/assets/icons/mapMark.png"),
                size: NMarker.autoSize,
                id: "curCoord",
                position: NLatLng(latitude, longitude));
            _controller!.addOverlay(marker);
          }
        },
        backgroundColor: const Color(0xffF6766E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          Icons.create,
          color: Color(0xffFFFFFF),
        ),
      ),
    );
  }
}
