import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/components/draft_tile.dart';
import 'package:start/models/draft.dart';
import 'package:start/models/user.dart';

class DraftList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('drafts')
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
                "Nenhum cheque encontrado.",
                textAlign: TextAlign.center,
              ),
            );

          default:
            return snapshot.data.documents.length == 0
                ? Center(
                    child: Text("Nenhum cheque foi cadastrado."),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (ctx, i) {
                      var current = snapshot.data.documents[i];
                      return DraftTile(
                        Draft(
                          id: current.documentID,
                          value: current['value'].toDouble(),
                          description: current['description'],
                          receiver: current['receiver'],
                          date: (current['date'] as Timestamp).toDate(),
                        ),
                      );
                    },
                  );
        }
      },
    );
  }
}
