import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/view/transactions_list.dart';
import 'package:start/view/transactions_form.dart';
import 'package:start/provider/transactions.dart';
import 'package:start/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Transactions(),
        )
      ],
      child: MaterialApp(
        title: 'Comprovantes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AppRoutes.HOME: (_) => TransactionList(),
          AppRoutes.TRANSACTION_FORM: (_) => TransactionForm(),
        },
      ),
    );
  }
}
