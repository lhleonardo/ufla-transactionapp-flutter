import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/components/transaction_tile.dart';
import 'package:start/provider/transactions.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Transactions transactions = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de transações'),
      ),
      body: ListView.builder(
        itemCount: transactions.count,
        itemBuilder: (ctx, i) => TransactionTile(
          transactions.byIndex(i),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
