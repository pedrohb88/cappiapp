import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  double amount = 0.0;
  DateTime date = DateTime.now();
  int category = 0;
  String description = "";

  final double fieldHeight = 35, fieldWidth = 130;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: fieldHeight,
                width: fieldWidth,
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    border: OutlineInputBorder(),
                    hintText: "R\$ 00,00",
                    labelText: "Quantia",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Container(
                height: fieldHeight,
                width: fieldWidth,
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    border: OutlineInputBorder(),
                    hintText: "DD/MM/AA",
                    labelText: "Data",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: fieldHeight,
                width: fieldWidth,
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    border: OutlineInputBorder(),
                    hintText: "R\$ 00,00",
                    labelText: "Categoria",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Container(
                height: fieldHeight,
                width: fieldWidth,
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    border: OutlineInputBorder(),
                    hintText: "Anote algo aqui",
                    labelText: "Descrição",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
