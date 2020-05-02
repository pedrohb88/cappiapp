import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFE4FFD4),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.remove_circle,
                color: Color(0xFFE00A2A),
              ),
              Text(
                'Gasto',
                style: TextStyle(
                  color: Color(0xFFE00A2A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
