import 'package:flutter/material.dart';

import 'package:cappiapp/models/cappi_api.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Transaction extends ChangeNotifier{
  double _value;
  String _type = 'out';
  String _label;
  DateTime _createdAt;
  String _category;

  bool sending = false;

  Transaction();

  Future<Transaction> send() async {

    this.sending = true;
    notifyListeners();

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth-token');

    final body = {
      "value": this._value.toString(),
    };

    if(this._label != null) body['label'] = this._label.toString();
    if(this._category != null) body['category'] = this._category.toString();
    if(this._createdAt != null) body['createdAt'] = this._createdAt.toString();

    final result = await CappiApi().post(
      route: '/transaction/${this.type}',
      body: body,
      headers: {"x-auth": token},
    );
 
    this.sending = false;
    notifyListeners();

    if(result != null) {
      return this;
    }
    return null;
  }

  clean(){
    _value = null;
    _label = null;
    _createdAt = null;
    _category = null;
  }

  set value(v) {
    _value = v;
    notifyListeners();
  }
  set type(v) {
    _type = v;
    notifyListeners();
  }
  set label(v) {
    _label = v;
    notifyListeners();
  }
  set createdAt(v) {
    _createdAt = v;
    notifyListeners();
  }
  set category(v) {
    _category = v;
    notifyListeners();
  }

  get value => _value;
  get type => _type;
  get label => _label;
  get createdAt => _createdAt;
  get category => _category;
}