import 'package:cappiapp/whatsapp_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cappiapp/models/transaction.dart';
import 'package:cappiapp/screens/home_screen/balance_notifier.dart';
import 'package:cappiapp/screens/home_screen/home_screen.dart';
import 'whatsapp_button.dart';

import 'package:cappiapp/models/user.dart';

class MainScreen extends StatefulWidget {
  final transaction = Transaction();
  final balanceNotifier = BalanceNotifier(isTransactionsVisible: false);

  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _navOptions = <Widget>[
    Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 32.0, right: 32.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Image.asset('assets/images/cappi_logo.png'),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                'Em breve :)',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    ),
    HomeScreen(),
    Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 32.0, right: 32.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Image.asset('assets/images/cappi_logo.png'),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                'Em breve :)',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                'Você também pode anotar seus gastos e fazer consultas direto pelo Whatsapp! É só clicar aqui em baixo.',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          WhatsappButton(),
          Consumer<User>(
            builder: (context, user, child) {
              return RaisedButton(
                child: Text('Logout'),
                onPressed: () {
                  user.logout();
                },
              );
            },
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    _buildLoader() {
      return AbsorbPointer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withAlpha(100),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return ChangeNotifierProvider<Transaction>(
      create: (context) => widget.transaction,
      child: Consumer<Transaction>(
        builder: (context, transaction, child) {
          return ChangeNotifierProvider<BalanceNotifier>(
            create: (context) => widget.balanceNotifier,
            child: Stack(
              children: <Widget>[
                Scaffold(
                  //resizeToAvoidBottomInset: false,
                  body: _navOptions[_selectedIndex],
                  bottomNavigationBar: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: Consumer<BalanceNotifier>(
                      builder: (context, balanceNotifier, child) {
                        var _isTransactionsVisible =
                            balanceNotifier.isTransactionsVisible;

                        return BottomNavigationBar(
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              icon: Icon(Icons.check),
                              title: Text('Metas'),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home),
                              title: Text('Home'),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.person),
                              title: Text('Perfil'),
                            ),
                          ],
                          onTap: _onItemTapped,
                          currentIndex: _selectedIndex,
                          backgroundColor: _isTransactionsVisible
                              ? Colors.white
                              : Color(0xFF008600),
                          selectedItemColor: _isTransactionsVisible
                              ? Color(0xFF008600)
                              : Colors.white,
                          unselectedItemColor: _isTransactionsVisible
                              ? Color(0x66008600)
                              : Color(0x66FFFFFF),
                        );
                      },
                    ),
                  ),
                ),
                if (transaction.sending) _buildLoader(),
              ],
            ),
          );
        },
      ),
    );
  }
}
