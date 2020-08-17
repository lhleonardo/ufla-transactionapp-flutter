import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:start/models/user.dart';
import 'package:start/routes/app_routes.dart';
import 'package:start/pages/transactions/transactions_list.dart';
import 'package:start/services/auth.dart';

import 'drafts/draft_list.dart';

class HomePage extends StatelessWidget {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('FinancesApp'),
          actions: [
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async {
                bool response = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title: Text("Confirmação"),
                    content: Text("Você deseja realmente sair, ${user.name}?"),
                    elevation: 24.0,
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text("Sim"),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("Não"),
                      )
                    ],
                  ),
                );
                if (response) {
                  _auth.signOut();
                }
              },
            )
          ],
          bottom: TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Color.fromRGBO(250, 250, 250, 1),
            ),
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return Container(
                width: MediaQuery.of(context).size.width / choices.length,
                child: Tab(
                  text: choice.title,
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: choices.map((Choice choice) {
            return choice.component;
          }).toList(),
        ),
        floatingActionButton: SpeedDial(
          animatedIconTheme: IconThemeData(size: 22.0),
          animationSpeed: 120,
          child: Icon(Icons.add),
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.receipt, color: Colors.white),
              backgroundColor: Colors.blue,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.TRANSACTION_FORM),
              label: 'Nova transferência',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.white,
            ),
            SpeedDialChild(
              child: Icon(Icons.drafts, color: Colors.white),
              backgroundColor: Colors.indigoAccent,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.DRAFT_FORM),
              label: 'Novo cheque',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.component});

  final String title;

  final Widget component;
}

List<Choice> choices = <Choice>[
  Choice(
    title: 'Transferências (DOC/TED)',
    component: TransactionList(),
  ),
  Choice(
    title: 'Cheques bancários',
    component: DraftList(),
  ),
];
