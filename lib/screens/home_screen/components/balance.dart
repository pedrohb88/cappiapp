import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Balance extends StatefulWidget {
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  Future<BalanceResponse> futureBalance;
  bool _isBalanceVisible = false;
  double _balance = 0.0;
  final String _hiddenBalanceText = '##,##';

  initState() {
    super.initState();
    futureBalance = fetchBalance();
  }

  Future<BalanceResponse> fetchBalance() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/albums/1', headers: {'x-auth': 'token-here'});
    if (response.statusCode == 200) {
      print(response.body);
      return BalanceResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch balance');
    }
  }

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
            color: Color(0xFF008600),
            padding: EdgeInsets.only(
                top: 16.0, left: 16.0, right: 16.0, bottom: 32.0),
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
                          child: FutureBuilder<BalanceResponse>(
                            future: futureBalance,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  'R\$ ' + (_isBalanceVisible ? snapshot.data.value : _hiddenBalanceText),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                );
                              }
                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },
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

class BalanceResponse {
  final String value;

  BalanceResponse({this.value});

  factory BalanceResponse.fromJson(Map<String, dynamic> json) {
    return BalanceResponse(
      value: json['title'],
    );
  }
}
