import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cappiapp/models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<String> categories;

  TransactionForm({@required this.formKey, @required this.categories});

  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  double amount = 0.0;
  DateTime date;
  int category = 0;
  String description = "";

  final double fieldHeight = 35, fieldWidth = 130;

  final marginBottom = EdgeInsets.only(bottom: 16.0);

  @override
  Widget build(BuildContext context) {
    return Consumer<Transaction>(
      builder: (context, transaction, child) {
        return Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: marginBottom,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: fieldHeight,
                      width: fieldWidth,
                      child: TextField(
                        onChanged: (val) {
                          val = val.trim();
                          if(val == '') transaction.value = null;
                          else
                            transaction.value = double.parse(val);
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
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
                        keyboardType: TextInputType.datetime,
                        onChanged: (val) {
                          transaction.createdAt = DateTime.parse(val);
                        },
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    foregroundDecoration: ShapeDecoration(
                      shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54)),
                    ),
                    height: fieldHeight,
                    width: fieldWidth,
                    child: Container(
                      color: Colors.white,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: category,
                          items: widget.categories.map((v) {
                            var i = widget.categories.indexOf(v);
                            return DropdownMenuItem(
                              value: i,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  v,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 14.0),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() {
                              category = v;
                            });

                            transaction.category = widget.categories[v];
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: fieldHeight,
                    width: fieldWidth,
                    child: TextField(
                      onChanged: (val) {
                        transaction.label = val;
                      },
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
      },
    );
  }
}
