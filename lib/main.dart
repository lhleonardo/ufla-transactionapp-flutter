import 'package:flutter/material.dart';
import 'package:start/view/drafts/draft_form.dart';
import 'package:start/view/home.dart';

import 'package:start/view/splash_screen.dart';
import 'package:start/view/transactions/transactions_form.dart';
import 'package:start/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comprovantes',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        AppRoutes.HOME: (_) => HomePage(),
        AppRoutes.TRANSACTION_FORM: (_) => TransactionForm(),
        AppRoutes.DRAFT_FORM: (_) => DraftForm(),
      },
      home: SplashScreenWidget(),
    );
  }
}
