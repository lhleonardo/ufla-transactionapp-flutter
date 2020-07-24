import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:start/models/transaction.dart';
import 'package:start/routes/app_routes.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile(this.transaction);

  void _openTransaction(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.TRANSACTION_FORM,
      arguments: transaction,
    );
  }

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
      onTap: () => _openTransaction(context),
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
        width: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              color: Color.fromRGBO(84, 88, 94, 1),
              icon: Icon(Icons.chevron_right),
              onPressed: () => _openTransaction(context),
            ),
          ],
        ),
      ),
    );
  }
}
