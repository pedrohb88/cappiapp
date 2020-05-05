import 'package:cappiapp/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  String value;
  String type = 'out';
  String label;
  String createdAt;
  String category;

  final icons = {
    'Casa': Icons.home,
    'Aluguel': Icons.home,
    'Transporte': Icons.directions_car,
    'Supermercado': Icons.local_grocery_store,
    'Alimentação': Icons.fastfood,
    'Educação': Icons.book,
    'Saúde': Icons.healing,
    'Contas': Icons.payment,
    'Assinaturas': Icons.payment,
    'Outro': Icons.attach_money,
    'Salário': Icons.attach_money,
    'Bolsa': Icons.attach_money,
    'Rendimentos': Icons.attach_money,
    'Vendas': Icons.attach_money,
    'Serviço': Icons.attach_money,
  };
  

  TransactionTile({
    @required this.value,
    this.type,
    this.label,
    this.createdAt,
    this.category,
  }) : assert(value != null);

  @override
  Widget build(BuildContext context) {
    
    if(createdAt.indexOf('/') == -1){
      final date = DateTime.parse(createdAt);
      createdAt = '${date.day}/${date.month}/${date.year}';
    }
    
    var val = type == 'in' ? 'R\$$value':'-R\$$value';

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(category != null ? icons[category] : Icons.attach_money),
                  Text(
                    category != null ? category : 'Sem categoria',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Text(
                val,
                style: TextStyle(fontSize: 18.0, color: type == 'in' ? Color(0xFF005700) : Color(0xFFe00a2a)),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(label != null ? label : ''),
                Text(createdAt),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
