import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _userId;
  Timer _theTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryTime != null &&
        _expiryTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  static const API_KEY = 'AIzaSyDDUkCzRzazg2qKhzLhLtguX4_JtqhmnbU';

  Future _authenticated(String email, String password, String urlType) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlType?key=$API_KEY';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] != null) {
        throw HttpException(bodyResponse['error']['message']);
      }

      _token = bodyResponse['idToken'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(bodyResponse['expiresIn']),
        ),
      );
      _userId = bodyResponse['localId'];
      notifyListeners();
      _autoLogout();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticated(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticated(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryTime = null;
    if (_theTimer != null) {
      _theTimer.cancel();
      _theTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_theTimer != null) {
      _theTimer.cancel();
    }
    final expiryTime = _expiryTime.difference(DateTime.now()).inSeconds;
    _theTimer = Timer(Duration(seconds: expiryTime), logout);
  }
}
