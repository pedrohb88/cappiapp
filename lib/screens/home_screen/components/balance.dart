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
    return ClipPath(
      clipper: MyCurveClipper(),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 16.0, left: 16.0, right: 16.0, bottom: 32.0),
            color: Color(0xFF008600),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Saldo',
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'R\$ ' +
                                (_isBalanceVisible
                                    ? _balance.toString()
                                    : _hiddenBalanceText),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon:
                          Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      onPressed: null,
                    ),
                    Center(
                      child: Text(
                        'Contas e extrato',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(
                _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: _chanceBalanceVisibility,
            ),
          ),
        ],
      ),
    );
  }
}

class MyCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height / 1.5);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 1.5);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => true;
}
