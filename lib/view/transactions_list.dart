import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/components/transaction_tile.dart';
import 'package:start/provider/transactions.dart';
import 'package:start/routes/app_routes.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Transactions transactions = Provider.of(context);
    final bodyElement = transactions.count == 0
        ? Center(
            child: Text(
              "Nenhuma transação cadastrada.\nClique no botão abaixo para adicionar",
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: transactions.count,
            itemBuilder: (ctx, i) => TransactionTile(
              transactions.byIndex(i),
            ),
          );
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de transações'),
      ),
      body: bodyElement,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.TRANSACTION_FORM,
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
