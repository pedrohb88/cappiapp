import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cappiapp/screens/home_screen/balance.dart';
import 'package:cappiapp/screens/home_screen/add_expense.dart';
import 'package:cappiapp/screens/home_screen/add_gain.dart';
import 'package:cappiapp/models/transaction.dart';

import 'package:cappiapp/screens/home_screen/balance_notifier.dart';

final marginBottom = EdgeInsets.only(bottom: 16.0);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BalanceNotifier>(
      builder: (context, balanceNotifier, child) {
        var widget;
        var _isTransactionsVisible = balanceNotifier.isTransactionsVisible;
        if (_isTransactionsVisible) {
          widget = Balance();
        } else {
          widget = ListView(
            children: <Widget>[
              Balance(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Consumer<Transaction>(
                  builder: (context, transaction, child) {
                    return Column(
                      children: <Widget>[
                        Container(
                          margin: marginBottom,
                          child: AddExpense(),
                        ),
                        Container(
                          margin: marginBottom,
                          child: AddGain(),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          );
        }

        return ChangeNotifierProvider<HomeScreenNotifier>(
          create: (context) => HomeScreenNotifier(
              isExpanseExpanded: true, isGainExpanded: false),
          child: Container(
            child: widget,
          ),
        );
      },
    );
  }
}

class HomeScreenNotifier extends ChangeNotifier {
  bool isGainExpanded;
  bool isExpanseExpanded;

  HomeScreenNotifier({
    @required this.isGainExpanded,
    @required this.isExpanseExpanded,
  })  : assert(isGainExpanded != null),
        assert(isExpanseExpanded != null);

  void collapseGain() {
    isGainExpanded = true;
    isExpanseExpanded = false;

    notifyListeners();
  }

  void collapseExpanse() {
    isGainExpanded = false;
    isExpanseExpanded = true;
    notifyListeners();
  }
}
