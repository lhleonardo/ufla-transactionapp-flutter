import "package:flutter/material.dart";
import 'package:progress_dialog/progress_dialog.dart';
import 'package:start/components/button.dart';
import 'package:start/components/input.dart';
import 'package:start/routes/app_routes.dart';
import 'package:start/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 120,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Entre para continuar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 48,
                    left: 16,
                    right: 16,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Input(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return "Preenchimento obrigatório";
                              }

                              return null;
                            },
                            onSaved: (newValue) => _email = newValue,
                            labelText: 'Endereço de e-mail',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Input(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return "Preenchimento obrigatório";
                              }

                              return null;
                            },
                            onSaved: (newValue) => _password = newValue,
                            obscureText: true,
                            labelText: "Senha",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Button(
                              text: "Entrar",
                              callback: () async {
                                try {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    await pr.show();
                                    await _auth.signIn(_email, _password);
                                    await pr.hide();
                                  }
                                } catch (error) {
                                  await pr.hide();
                                  String message;
                                  switch (error.code) {
                                    case 'ERROR_INVALID_EMAIL':
                                    case 'ERROR_WRONG_PASSWORD':
                                    case 'ERROR_USER_NOT_FOUND':
                                      message =
                                          'Usuário e/ou senha incorretos.';
                                      break;
                                    case 'ERROR_USER_DISABLED':
                                    case 'ERROR_TOO_MANY_REQUESTS':
                                      message =
                                          'Falha ao autenticar. Tente mais tarde.';
                                      break;
                                  }
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) => AlertDialog(
                                      title: Text("Falha ao entrar"),
                                      content: Text(message),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                      elevation: 24.0,
                                    ),
                                  );
                                } finally {
                                  await pr.hide();
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Button(
                              text: 'Criar uma conta',
                              callback: () => Navigator.of(context)
                                  .pushNamed(AppRoutes.REGISTER),
                              isFit: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
