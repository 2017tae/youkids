import 'package:flutter/material.dart';

class RegistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextField(
          decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          isDense: true,
          contentPadding: EdgeInsets.all(12),
          labelText: '닉네임',
          )
              ),
            SizedBox(height: 16),
            TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  labelText: '배우자',
                )
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Register logic here
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}