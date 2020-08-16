import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:start/routes/app_routes.dart';
import 'package:start/view/transactions/transactions_list.dart';

import 'drafts/draft_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('FinancesApp'),
          bottom: TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Color.fromRGBO(250, 250, 250, 1),
            ),
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return Tab(
                text: choice.title,
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
