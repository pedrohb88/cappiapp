import 'package:cappiapp/screens/home_screen/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cappiapp/models/user.dart';

import 'package:cappiapp/screens/home_screen/home_screen.dart';
import 'package:cappiapp/models/transaction.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();

  final categories = [
    'Categoria',
    'Casa',
    'Aluguel',
    'Transporte',
    'Supermercado',
    'Alimentação',
    'Educação',
    'Saúde',
    'Contas',
    'Família',
    'Assinaturas',
    'Outro'
  ];

  showCustomDialog(msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenNotifier>(
      builder: (context, homeScreenNotifier, child) {
        return Consumer<Transaction>(
          builder: (context, transaction, child) {
            return GestureDetector(
              onTap: () {
                homeScreenNotifier.collapseExpanse();
                transaction.type = 'out';
                transaction.value = null;
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 0, // has the effect of softening the shadow
                      spreadRadius:
                          1.0, // has the effect of extending the shadow
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
                        Consumer<User>(
                          builder: (context, user, child) {
                            return RaisedButton(
                              disabledColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              textColor: Colors.white,
                              onPressed: transaction.value != null &&
                                      transaction.type == 'out'
                                  ? () async {
                                      print('adicionar gasto');

                                      final result = await transaction.send();
                                      if (result != null) {
                                        showCustomDialog('Gasto adicionado com sucesso!');

                                        user.updateBalance(transaction.value, transaction.type);
                                        transaction.clean();

                                      } else
                                        showCustomDialog(
                                            'Falha ao adicionar gasto');
                                    }
                                  : null,
                              color: Color(0xFFE00A2A),
                              child: Text('Adicionar'),
                            );
                          },
                        ),
                      ],
                    ),
                    if (homeScreenNotifier.isExpanseExpanded) Divider(),
                    if (homeScreenNotifier.isExpanseExpanded)
                      TransactionForm(
                          formKey: _formKey, categories: categories),
                  ],
                ),
              ),
            );
          },
        ); //gesture
      },
    );
  }
}
