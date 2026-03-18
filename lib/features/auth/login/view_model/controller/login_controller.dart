import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  void isHidden() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  void isHiddenConfirmPassword() {
    isConfirmPasswordHidden = !isConfirmPasswordHidden;
    notifyListeners();
  }
}
