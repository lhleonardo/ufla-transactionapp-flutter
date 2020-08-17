import "package:flutter/material.dart";
import 'package:progress_dialog/progress_dialog.dart';
import 'package:start/components/button.dart';
import 'package:start/components/input.dart';
import 'package:start/routes/app_routes.dart';
import 'package:start/services/auth.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final Map<String, String> data = {};

  final AuthService _authService = AuthService();
  final key = GlobalKey<FormState>();

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
        child: Form(
          key: key,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
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
                        size: 90,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Cadastre-se",
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
                height: MediaQuery.of(context).size.height * 0.7,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 28,
                    left: 16,
                    right: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Input(
                            labelText: 'Nome completo',
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return "Preenchimento obrigatório";
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              data['name'] = newValue;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Input(
                            labelText: 'Endereço de e-mail',
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) {
                              data['email'] = newValue;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return "Preenchimento obrigatório";
                              }

                              return null;
                            },
                          ),
                        ),
                        Input(
                            labelText: "Senha",
                            obscureText: true,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return "Preenchimento obrigatório";
                              }

                              if (value.length < 6) {
                                return "Precisa ter mais que 6 letras";
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              data['password'] = newValue;
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Button(
                              text: "Cadastrar",
                              callback: () async {
                                if (key.currentState.validate()) {
                                  key.currentState.save();
                                  await pr.show();
                                  try {
                                    dynamic user = await _authService
                                        .registerWithEmailWithPassword(
                                            data['name'],
                                            data['email'].trim(),
                                            data['password'].trim());
                                    await pr.hide();
                                    if (user != null) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              AppRoutes.WRAPPER,
                                              (route) => false);
                                    }
                                  } catch (error) {
                                    await pr.hide();
                                    String message;
                                    switch (error.code) {
                                      case 'ERROR_WEAK_PASSWORD':
                                        message = 'Senha muito fraca.';
                                        break;
                                      case 'ERROR_INVALID_EMAIL':
                                        message = 'E-mail inválido.';
                                        break;
                                      case 'ERROR_EMAIL_ALREADY_IN_USE':
                                        message = 'Este e-mail já está em uso.';
                                        break;
                                    }

                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (_) => AlertDialog(
                                        title: Text("Falha no registro"),
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
                              text: 'Já tem uma conta?',
                              callback: () => Navigator.of(context).pop(),
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
