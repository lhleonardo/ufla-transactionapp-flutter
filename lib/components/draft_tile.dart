import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:start/models/draft.dart';
import 'package:start/routes/app_routes.dart';

class DraftTile extends StatelessWidget {
  final Draft draft;
  const DraftTile(this.draft);

  void _openDraft(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.DRAFT_FORM,
      arguments: draft,
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
        child: Icon(Icons.drafts),
      ),
      onTap: () => _openDraft(context),
      title: Text(
        draft.receiver,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        formatter.format(draft.value),
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
              onPressed: () => _openDraft(context),
            ),
          ],
        ),
      ),
    );
  }
}
