import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:start/models/transaction.dart' as TransactionModel;
import 'package:start/models/user.dart';

class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  String _selectedType;

  bool isLoading = false;
  final _formatter = DateFormat('dd/MM/yyyy');
  final _form = GlobalKey<FormState>();

  final Map<String, Object> _values = {};

  final _dateController = TextEditingController();

  User _user;

  TransactionModel.Transaction _openTransaction;

  String _textEmptyValidator(String newValue) {
    if (newValue == null || newValue.isEmpty || newValue.trim().isEmpty) {
      return "Preenchimento obrigatório";
    }
    return null;
  }

  String _textLimitedValidator(String newValue) {
    String textValidation = _textEmptyValidator(newValue);
    if (textValidation != null) return textValidation;

    if (newValue.trim().length <= 3) {
      return "Valor menor que quatro letras";
    }

    return null;
  }

  String _textNumberValidator(String newValue) {
    String textValidation = _textEmptyValidator(newValue);
    if (textValidation != null) return textValidation;

    double convertedValue = double.parse(newValue);

    if (convertedValue <= 0) {
      return "Valor precisa ser maior que zero";
    }

    return null;
  }

  void _saveOnInstance(String property, Object value) {
    _values[property] = value;
  }

  void _prepareFormData(TransactionModel.Transaction transaction) {
    if (transaction != null) {
      _openTransaction = transaction;
      _values["id"] = transaction.id;

      _values["type"] = transaction.type;
      setState(() {
        _selectedType = transaction.type;
      });

      _values["value"] = transaction.value == null ? "" : transaction.value;

      _values["date"] = transaction.date;
      _dateController.text = _formatter.format(transaction.date);

      _values["description"] = transaction.description;

      _values["to.agency"] = transaction.to.agency;
      _values["to.account"] = transaction.to.account;
      _values["to.owner"] = transaction.to.owner;
    }
  }

  void _save() async {
    Map<String, Object> data = {
      'description': _values['description'],
      'value': _values['value'],
      'date': _values['date'],
      'type': _selectedType,
      'owner': _user.uid,
      'to': {
        'agency': _values['to.agency'],
        'account': _values['to.account'],
        'owner': _values['to.owner'],
      }
    };
    if (_values.containsKey('id')) {
      // update
      await Firestore.instance
          .collection('transactions')
          .document(_values['id'])
          .setData(data);
    } else {
      // insert
      await Firestore.instance.collection('transactions').add(data);
    }
  }

  void _delete() async {
    await Firestore.instance
        .collection('transactions')
        .document(_values['id'])
        .delete();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final TransactionModel.Transaction transaction =
        ModalRoute.of(context).settings.arguments;
    _prepareFormData(transaction);

    _user = Provider.of<User>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _openTransaction == null
            ? Text('Nova transferência')
            : Text('Editar'),
        actions: <Widget>[
          Visibility(
            visible: _values['id'] != null,
            child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      title: Text("Confirmação"),
                      content: Text(
                          "Essa ação não pode ser desfeita. Deseja realmente excluir a transação?"),
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
                  ).then((confirmation) async {
                    if (confirmation == true) {
                      _delete();

                      // Provider.of<Transactions>(context, listen: false)
                      //     .remove(_openTransaction);
                      Navigator.of(context).pop();
                    }
                  });
                }),
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (!_form.currentState.validate()) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => AlertDialog(
                    title: Text("Validação de dados"),
                    content: Text(
                        "Há informações que precisam de sua atenção. Confira!"),
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
                return;
              }

              if (_selectedType == null || _selectedType.isEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => AlertDialog(
                    title: Text("Validação de dados"),
                    content: Text(
                        "O tipo de transferência deve ser preenchido. Confira!"),
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

                return;
              }
              _form.currentState.save();

              _save();

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "Informações básicas",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextFormField(
                          initialValue: _values['description'],
                          onSaved: (newValue) =>
                              _saveOnInstance('description', newValue),
                          validator: _textLimitedValidator,
                          decoration: InputDecoration(
                              labelText: 'Descrição da transferência'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextFormField(
                          initialValue: _values['value'] == null
                              ? ""
                              : _values['value'].toString(),
                          onSaved: (newValue) =>
                              _saveOnInstance('value', double.parse(newValue)),
                          validator: _textNumberValidator,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Valor (R\$)'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: TextFormField(
                          controller: _dateController,
                          onSaved: (newValue) => _saveOnInstance(
                              'date', _formatter.parse(newValue)),
                          validator: _textEmptyValidator,
                          readOnly: true,
                          onTap: () {
                            var currentDate = _dateController.text != null &&
                                    _dateController.text.isNotEmpty
                                ? _formatter.parse(_dateController.text)
                                : DateTime.now();
                            var result = showDatePicker(
                              context: context,
                              initialDate: currentDate,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2080),
                            );

                            result.then((value) => _dateController.text =
                                _formatter.format(value));
                          },
                          decoration: InputDecoration(
                            hintText: 'Data da operação',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "Tipo de transferência",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      RadioListTile(
                        title: Text("TED"),
                        subtitle: Text(
                            "Transferência no mesmo dia com valor podendo ser maior que R\$5.000,00"),
                        value: 'TED',
                        groupValue: _selectedType,
                        onChanged: (String value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text("DOC"),
                        subtitle: Text(
                            "Transferência para o próximo dia útil com valor menor que R\$5.000,00"),
                        value: 'DOC',
                        groupValue: _selectedType,
                        onChanged: (String value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                      ),
                      Column(
                        // grupo de transferências destino
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                            child: Text(
                              "Destinatário",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: TextFormField(
                                    initialValue: _values['to.agency'],
                                    validator: _textLimitedValidator,
                                    onSaved: (newValue) =>
                                        _saveOnInstance('to.agency', newValue),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Agência',
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: _textLimitedValidator,
                                    initialValue: _values['to.account'],
                                    onSaved: (newValue) =>
                                        _saveOnInstance('to.account', newValue),
                                    decoration: InputDecoration(
                                      labelText: 'Conta',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: TextFormField(
                              validator: _textLimitedValidator,
                              initialValue: _values['to.owner'],
                              onSaved: (newValue) =>
                                  _saveOnInstance('to.owner', newValue),
                              decoration: InputDecoration(
                                labelText: 'Nome do titular',
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
