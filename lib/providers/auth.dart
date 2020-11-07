import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiresIn;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiresIn != null &&
        _expiresIn.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate({
    String email,
    String senha,
    String segmentUrl,
  }) async {
    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:$segmentUrl?key=AIzaSyC_sgI4Z5CySy8qZXqkiTKJpdA_mL1dRH0',
      body: json.encode({
        'email': email,
        'password': senha,
        'returnSecureToken': true,
      }),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _expiresIn = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    await _authenticate(
      email: email,
      senha: password,
      segmentUrl: 'signUp',
    );
  }

  Future<void> login(String email, String password) async {
    await _authenticate(
      email: email,
      senha: password,
      segmentUrl: 'signInWithPassword',
    );
  }
}
