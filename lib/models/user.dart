import 'package:flutter/material.dart';

class User extends ChangeNotifier {

  String name;
  String email;
  double balance;

  User({
    this.name,
    this.email,
    this.balance,
  });

  update(name, email, balance){
    this.name = name;
    this.email = email;
    this.balance = balance;

    print('usuário alterado: ${this.email}');

    notifyListeners();
  }

  updateBalance(value, type){
    if(type == 'in')
      this.balance += value;
    else 
      this.balance -= value;
    notifyListeners();
  }

}