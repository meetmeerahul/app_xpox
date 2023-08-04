import 'package:app_xpox/models/user.dart';
import 'package:app_xpox/resourses/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

