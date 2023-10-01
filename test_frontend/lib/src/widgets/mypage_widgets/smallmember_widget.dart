import 'package:flutter/material.dart';
import 'package:youkids/src/models/mypage_models/user_model.dart';

class SmallMemberWidget extends StatelessWidget {
  final UserModel member;
  const SmallMemberWidget({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          member.profileImage != null
              ? Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(member.profileImage!),
                        fit: BoxFit.cover),
                  ),
                )
              : Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                        image: AssetImage('lib/src/assets/icons/logo.png'),
                        fit: BoxFit.cover),
                  ),
                ),
          const SizedBox(
            height: 3,
          ),
          Text(member.nickname ?? ''),
        ],
      ),
    );
  }
}
