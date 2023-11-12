import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/firebase/auth.dart';
import 'package:tp_dev_mobile/model/user.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  UserData? get getUser => _userData;

  refreshUser() async {
    UserData userData = await AuthMethods().getUserDetails();
    _userData = userData;
    notifyListeners();
  }
}
