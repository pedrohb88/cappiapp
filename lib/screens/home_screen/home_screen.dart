import 'package:cappiapp/screens/home_screen/components/add_expense.dart';
import 'package:cappiapp/screens/home_screen/components/add_gain.dart';
import 'package:flutter/material.dart';

import 'components/balance.dart';

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Balance(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                AddExpense(),
                SizedBox(
                  height: 18,
                ),
                AddGain(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
