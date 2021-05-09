import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  DateTime _expiryDate;
 

  Future<void> logout() async {
    _expiryDate = null;
  
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    print('logout');
    notifyListeners();
  }


  Future<void> _authenticate(
      String email, String password, String function) async {
    try {
      var url;
      var response;
      if (function == "signUp") {
        url = "https://nodejs-register-login-app.herokuapp.com/";
        response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "email": email,
            "username": email,
            "password": password,
            "passwordConf": password
          }),
        );
      } else {
        url = "https://nodejs-register-login-app.herokuapp.com/login";
        response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "email": email,
            "password": password,
          }),
        );
      }
      print(url);
      print('debug' + response.body);
      var responseData = json.decode(response.body);

      if (responseData['Success'].toString() == 'Email is already used.') {
        throw HttpException('Email is already used');
      }else if(responseData['Success'].toString() =='This Email Is not regestered!'){
        throw HttpException('This Email Is not regestered!');
      }else if(responseData['Success'].toString() =='Wrong password!'){
        throw HttpException('Wrong password!');
      } else if (responseData['Success'].toString() ==
              'You are regestered,You can login now.' ||
          responseData['Success'].toString() == 'Success!') {
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: 7200,
          ),
        );
        final pref = await SharedPreferences.getInstance();
        pref.setString('userData', _expiryDate.toIso8601String());
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }
    print(1);
    final extractedData = pref.getString('userData');
    final expiryDate = DateTime.parse(extractedData);
    if (expiryDate.isBefore(DateTime.now())) {
      logout();
      return false;
    }
    print(2);
    _expiryDate = expiryDate;
    return true;
  }

  Future<void> signup(String email, String password) {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signin(String email, String password) {
    return _authenticate(email, password, "signIn");
  }
}
