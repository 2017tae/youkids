import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignIn get googleSignIn => _googleSignIn;

  Future<void> logout() async {
    await _googleSignIn.signOut();
    notifyListeners();
  }
}
