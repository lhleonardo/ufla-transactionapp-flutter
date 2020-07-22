import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:start/models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile(this.transaction);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'pt-BR',
      symbol: 'R\$',
    );
    return ListTile(
      leading: CircleAvatar(
        foregroundColor: Colors.white,
        child: Text(transaction.type),
      ),
      title: Text(
        transaction.to.owner,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        formatter.format(transaction.value),
        style: TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              color: Colors.brown,
              icon: Icon(Icons.mode_edit),
              onPressed: () {},
            ),
            IconButton(
              color: Colors.red,
              icon: Icon(Icons.delete),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
