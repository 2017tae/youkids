import 'package:flutter/material.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';

class SmallMemberWidget extends StatelessWidget {
  final String memberName;
  const SmallMemberWidget({
    super.key,
    required this.memberName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(tmpChildStoryIcon[1].imgUrl),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(memberName),
        ],
      ),
    );
  }
}
