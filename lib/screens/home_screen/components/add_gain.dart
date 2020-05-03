import 'package:cappiapp/screens/home_screen/components/transaction_form.dart';
import 'package:flutter/material.dart';
import '../home_screen.dart';

class AddGain extends StatefulWidget {

  @override
  _AddGainState createState() => _AddGainState();
}

class _AddGainState extends State<AddGain> {

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFE4FFD4),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 0, // has the effect of softening the shadow
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
                      color: Color(0xFF0be044),
                    ),
                    Text(
                      'Receita',
                      style: TextStyle(
                        color: Color(0xFF0be044),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF0be044),
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
      ),
    );
  }
}
