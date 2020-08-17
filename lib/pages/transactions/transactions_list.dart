import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/components/transaction_tile.dart';
import 'package:start/models/account.dart';
import 'package:start/models/transaction.dart' as TransactionModel;
import 'package:start/models/user.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('transactions')
          .where('owner', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(
              "Erro: ${snapshot.error}",
              textAlign: TextAlign.center,
            ),
          );

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.none:
            return Center(
              child: Text(
                "Nenhuma transação cadastrada",
                textAlign: TextAlign.center,
              ),
            );

          default:
            return snapshot.data.documents.length == 0
                ? Center(
                    child: Text(
                      "Nenhuma transferência cadastrada.",
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (ctx, i) {
                      var current = snapshot.data.documents[i];
                      return TransactionTile(TransactionModel.Transaction(
                        id: current.documentID,
                        type: current['type'],
                        to: Account(
                          agency: current['to']['agency'],
                          account: current['to']['account'],
                          owner: current['to']['owner'],
                        ),
                        value: current['value'],
                        description: current['description'],
                        date: DateTime.now(),
                      ));
                    },
                  );
        }
      },
    );
  }
}
