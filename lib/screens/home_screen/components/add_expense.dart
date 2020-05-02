import 'package:cappiapp/screens/home_screen/components/transaction_form.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFE4FFD4),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 2.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              GestureDetector(
                onTap: null,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE00A2A),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  width: 100,
                  height: 25,
                  child: Center(
                    child: Text(
                      'Adicionar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          if (expanded) Divider(),
          if (expanded) TransactionForm(),
        ],
      ),
    );
  }
}
