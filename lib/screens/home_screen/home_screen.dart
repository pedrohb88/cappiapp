import 'package:cappiapp/screens/home_screen/components/add_expense.dart';
import 'package:flutter/material.dart';

import 'components/balance.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Balance(),
          SizedBox(
            height: 16,
          ),
          AddExpense(),
        ],
      ),
    );
  }
}
