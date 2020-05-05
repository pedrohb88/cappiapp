import 'package:cappiapp/models/json_request.dart';
import 'package:cappiapp/models/transaction.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cappiapp/models/user.dart';
import 'package:cappiapp/screens/home_screen/components/transaction_tile.dart';

import 'balance_notifier.dart';
import 'package:cappiapp/screens/home_screen/components/balance_notifier.dart';

class Balance extends StatefulWidget {
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  bool _isBalanceVisible = true;
  final String _hiddenBalanceText = '##,##';

  void _chanceBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  Future<List<Widget>> _buildListItems() async {
    var items = <Widget>[];

    print('buscando lista');

    items.add(
      Text(
        'Extrato',
        style: TextStyle(fontSize: 18.0),
      ),
    );

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth-token');

    final result = await JsonRequest().get(route: '/transaction', headers: {
      "x-auth": token,
    });

    var transactions = [];
    if (result != null) {
      transactions = result['body'];
    }

    print('transaction ${transactions.toString()}');

    for (int i = transactions.length - 1; i >= 0; i--) {
      items.add(
        TransactionTile(
          value: transactions[i]['value'].toString(),
          type: transactions[i]['type'] != null
              ? transactions[i]['type'].toString()
              : null,
          label: transactions[i]['label'] != null
              ? transactions[i]['label'].toString()
              : null,
          createdAt: transactions[i]['createdAt'] != null
              ? transactions[i]['createdAt'].toString()
              : null,
          category: transactions[i]['category'] != null
              ? transactions[i]['category'].toString()
              : null,
        ),
      );
    }

    print('terminou de buscar');

    return items;
  }

  _buildTransactionList(_isTransactionsVisible) {
    if (_isTransactionsVisible) {
      return Card(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(24.0),
          child: FutureBuilder<List<Widget>>(
            future: _buildListItems(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
              var widget;

              if (snapshot.hasData) {
                print(snapshot.data.toString());
                widget = ListView(
                  children: snapshot.data,
                );
              } else {
                widget = Center(child: CircularProgressIndicator());
              }

              return widget;
            },
          ),
        ),
      );
    } else {
      print('entrando aqui tbm');
      return Container(width: 0,height: 0,);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('balance visible? $_isBalanceVisible');


    return Consumer<BalanceNotifier>(
      builder: (context, balanceNotifier, child) {

        var widget;
        var _isTransactionsVisible = balanceNotifier.isTransactionsVisible;
        print('expand? $_isTransactionsVisible');

        if (_isTransactionsVisible) {
          widget = Stack(
            children: <Widget>[
              Container(
                color: Color(0xFF008600),
                padding: EdgeInsets.only(
                    top: 16.0, left: 16.0, right: 16.0, bottom: 32.0),
                child: Container(
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
                                child: Consumer<User>(
                                  builder: (context, user, child) {
                                    var s = '';
                                    var b = user.balance;
                                    if (b < 0) {
                                      s = '-';
                                      b *= -1;
                                    }

                                    var balance = '${s}R\$$b';
                                    var text = Text(
                                      balance,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    );

                                    return _isBalanceVisible
                                        ? Container(
                                            child: Center(child: text),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                18,
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                18,
                                            color: Colors.grey.withAlpha(180),
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: _isTransactionsVisible
                                  ? MediaQuery.of(context).size.height * 0.6
                                  : 0.0,
                              child: _buildTransactionList(_isTransactionsVisible),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  print('expandir extrato');

                                  balanceNotifier.setTransactionsVisible(false);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      _isTransactionsVisible
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                    Center(
                                      child: Text(
                                        'Extrato',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
          );
        } else {
          print('entrou no esperado');
          widget = ClipPath(
            clipper: MyCurveClipper(),
            child: Stack(
              children: <Widget>[
                Container(
                  color: Color(0xFF008600),
                  padding: EdgeInsets.only(
                      top: 16.0, left: 16.0, right: 16.0, bottom: 32.0),
                  child: Container(
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
                                  child: Consumer<User>(
                                    builder: (context, user, child) {
                                      var s = '';
                                      var b = user.balance;
                                      if (b < 0){
                                          s = '-';
                                          b *= -1;
                                      }

                                      var balance = '${s}R\$$b';
                                      var text = Text(
                                        balance,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      );

                                      return _isBalanceVisible
                                          ? Container(
                                              child: Center(child: text),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  18,
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  18,
                                              color: Colors.grey.withAlpha(180),
                                            );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            print('expandir extrato');

                            balanceNotifier.setTransactionsVisible(true);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white),
                                onPressed: null,
                              ),
                              Center(
                                child: Text(
                                  'Extrato',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      _isBalanceVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: _chanceBalanceVisibility,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          height: _isTransactionsVisible ? double.infinity : null,
          child: widget,
        );
      },
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
