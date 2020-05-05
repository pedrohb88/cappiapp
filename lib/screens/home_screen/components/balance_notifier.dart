import 'package:flutter/material.dart';

class BalanceNotifier extends ChangeNotifier {
  bool isTransactionsVisible;

  BalanceNotifier({this.isTransactionsVisible});

  setTransactionsVisible(isVisible) {
    isTransactionsVisible = isVisible;
    print('dentro do notifier: $isTransactionsVisible');
    notifyListeners();
  }
}
