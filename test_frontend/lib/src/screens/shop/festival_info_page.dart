import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FestivalInfoPage extends StatefulWidget {
  @override
  _FestivalInfoPageState createState() => _FestivalInfoPageState();
}

enum InfoType { PerformanceInfo, SalesInfo, ReviewInfo }


class _FestivalInfoPageState extends State<FestivalInfoPage> {


  InfoType _selectedInfoType = InfoType.PerformanceInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text('공연정보'),
                onPressed: () {
                  setState(() {
                    _selectedInfoType = InfoType.PerformanceInfo;
                  });
                },
              ),
              ElevatedButton(
                child: Text('판매정보'),
                onPressed: () {
                  setState(() {
                    _selectedInfoType = InfoType.SalesInfo;
                  });
                },
              ),
              ElevatedButton(
                child: Text('관람후기'),
                onPressed: () {
                  setState(() {
                    _selectedInfoType = InfoType.ReviewInfo;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: _buildContentBasedOnSelection(_selectedInfoType),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBasedOnSelection(InfoType type) {
    switch (type) {
      case InfoType.PerformanceInfo:
        return _buildPerformanceInfo();
      case InfoType.SalesInfo:
        return _buildSalesInfo();
      case InfoType.ReviewInfo:
        return _buildReviewInfo();
      default:
        return SizedBox.shrink(); // This shouldn't happen
    }
  }

  Widget _buildPerformanceInfo() {
    // 여기에 공연정보 관련 위젯을 반환하십시오.
    return Text('공연 정보를 여기에 표시합니다.');
  }

  Widget _buildSalesInfo() {
    // 여기에 판매정보 관련 위젯을 반환하십시오.
    return Text('판매 정보를 여기에 표시합니다.');
  }

  Widget _buildReviewInfo() {
    // 여기에 관람후기 관련 위젯을 반환하십시오.
    return Text('관람 후기를 여기에 표시합니다.');
  }
}
