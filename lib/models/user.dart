import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'cappi_api.dart';

class User extends ChangeNotifier {
  String name;
  String email;
  double balance;
  bool isLogged = false;

  User({
    this.name,
    this.email,
    this.balance,
  });

  verifyCode(email, verificationCode) async {

    final result = await CappiApi().post(route: '/user/verifyCode', body: {
      'email': email,
      'verificationCode': verificationCode
    });

    if(result == null) return false;
    return true;
  }

  update({name, email, balance, isLogged}) {
    this.name = name;
    this.email = email;
    this.balance = balance;
    this.isLogged = isLogged;

    notifyListeners();
  }

  register({name, email, verificationCode}) async {
    var result = await CappiApi().post(route: '/user', body: {
      "name": name,
      "email": email,
      "verificationCode": verificationCode,
    });

    if (result == null) {
      return false;
    } else {
      final storage = new FlutterSecureStorage();
      await storage.write(
          key: 'auth-token', value: result['headers']['x-auth']);

      final body = result['body']['data'];
      this.update(
        isLogged: true,
        name: body['name'],
        email: body['email'],
        balance: body['totalBalance'].toDouble(),
      );
      return true;
    }
  }

  login(email, verificationCode) async {
    final result = await CappiApi().post(
        route: '/users/login',
        body: {"email": email, "verificationCode": verificationCode});

    if (result == null) {
      return false;
    } else {
      final storage = new FlutterSecureStorage();

      await storage.write(
          key: 'auth-token', value: result['headers']['x-auth']);

      final body = result['body'];
      this.update(
        isLogged: true,
        name: body['name'],
        email: body['email'],
        balance: body['totalBalance'].toDouble(),
      );
      return true;
    }
  }

  logout() async {
    //TODO: delete token from the database
    /* 
      API.deleteToken(token);
    */

    final storage = FlutterSecureStorage();
    await storage.delete(key: 'auth-token');

    this.update(isLogged: false);
  }

  updateBalance(value, type) {
    if (type == 'in')
      this.balance += value;
    else
      this.balance -= value;
    notifyListeners();
  }
}
