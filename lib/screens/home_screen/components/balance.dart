import 'package:flutter/material.dart';

class Balance extends StatefulWidget {
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  bool _isBalanceVisible = false;
  double _balance = 800.0;
  final String _hiddenBalanceText = '##,##';

  void _chanceBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

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
            children: <Widget>[
              Icon(Icons.attach_money),
              Text('Saldo'),
              Expanded(
                child: Center(
                  child: Text(
                    'R\$ ' +
                        (_isBalanceVisible
                            ? _balance.toString()
                            : _hiddenBalanceText),
                    style: TextStyle(
                      color: Color(0xFF005700),
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_isBalanceVisible? Icons.visibility : Icons.visibility_off),
                onPressed: _chanceBalanceVisibility,
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: null,
              ),
              Center(
                child: Text('Contas e extrato'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
