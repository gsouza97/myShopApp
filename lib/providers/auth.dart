import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/auth_exceptions.dart';

class Auth with ChangeNotifier {
  static const _singUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBjOUqV_ANyQhxKbfk6D1qfWdb8xIb-7mA';
  static const _loginUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBjOUqV_ANyQhxKbfk6D1qfWdb8xIb-7mA';

  DateTime _expireDate;
  String _token;
  String _userId;
  Timer _logoutTimer;

  bool get isAuthenticated {
    return token != null;
  }

  String get userId {
    return isAuthenticated ? _userId : null;
  }

  String get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      _loginUrl,
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final responseBody = json.decode(response.body);
    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _userId = responseBody['localId'];
      _token = responseBody['idToken'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> singup(String email, String password) async {
    final response = await http.post(
      _singUpUrl,
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseBody = json.decode(response.body);
    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    final timeToLogout = _expireDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
