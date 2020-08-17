import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/models/user.dart';
import 'package:start/pages/home.dart';

import 'auth/login.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    print(user);
    return user == null ? LoginPage() : HomePage();
  }
}
