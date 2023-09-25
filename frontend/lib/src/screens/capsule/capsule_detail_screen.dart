import 'package:flutter/material.dart';
import 'package:youkids/src/screens/capsule/capsule_list_screen.dart';

class CapsuleDetailScreen extends StatelessWidget {
  final Capsule capsule;

  CapsuleDetailScreen(this.capsule);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capsule.name),
      ),
      body: Center(
        child: Text(capsule.name),
      ),
    );
  }
}
