import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/pages/auth/register.dart';
import 'package:start/pages/drafts/draft_form.dart';

import 'package:start/pages/splash_screen.dart';
import 'package:start/pages/transactions/transactions_form.dart';
import 'package:start/pages/wrapper.dart';
import 'package:start/routes/app_routes.dart';
import 'package:start/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Comprovantes',
        // debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routes: {
          AppRoutes.WRAPPER: (_) => Wrapper(),
          AppRoutes.TRANSACTION_FORM: (_) => TransactionForm(),
          AppRoutes.DRAFT_FORM: (_) => DraftForm(),
          AppRoutes.REGISTER: (_) => RegisterForm(),
        },
        home: SplashScreenWidget(),
      ),
    );
  }
}
