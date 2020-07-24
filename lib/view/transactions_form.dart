import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:start/models/account.dart';
import 'package:start/models/transaction.dart';
import 'package:start/provider/transactions.dart';

class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  String _selectedType;
  final _formatter = DateFormat('dd/MM/yyyy');
  final _form = GlobalKey<FormState>();

  final Map<String, Object> _values = {};

  final _dateController = TextEditingController();

  Transaction _openTransaction;

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

  void _prepareFormData(Transaction transaction) {
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

      _values["from.agency"] = transaction.from.agency;
      _values["from.account"] = transaction.from.account;
      _values["from.owner"] = transaction.from.owner;

      _values["to.agency"] = transaction.to.agency;
      _values["to.account"] = transaction.to.account;
      _values["to.owner"] = transaction.to.owner;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Transaction transaction = ModalRoute.of(context).settings.arguments;
    _prepareFormData(transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _openTransaction == null
            ? Text('Formulário')
            : Text('Editar Informações'),
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
                            Provider.of<Transactions>(context, listen: false)
                                .remove(_openTransaction);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text("Sim"),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Não"),
                        )
                      ],
                    ),
                  );
                }),
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
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

              Provider.of<Transactions>(context, listen: false).put(
                Transaction(
                  id: _values['id'],
                  description: _values['description'],
                  value: _values['value'],
                  date: _values['date'],
                  type: _selectedType,
                  from: Account(
                      agency: _values['from.agency'],
                      account: _values['from.account'],
                      owner: _values['from.owner']),
                  to: Account(
                      agency: _values['to.agency'],
                      account: _values['to.account'],
                      owner: _values['to.owner']),
                ),
              );

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
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
                    onSaved: (newValue) =>
                        _saveOnInstance('date', _formatter.parse(newValue)),
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

                      result.then((value) =>
                          _dateController.text = _formatter.format(value));
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
                      print(_selectedType + ' ' + value);
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
                      print(_selectedType + ' ' + value);
                    });
                  },
                ),
                Column(
                  // grupo de transferências origem
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        "Origem",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: TextFormField(
                              initialValue: _values['from.agency'],
                              validator: _textEmptyValidator,
                              onSaved: (newValue) =>
                                  _saveOnInstance('from.agency', newValue),
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
                              initialValue: _values['from.account'],
                              validator: _textEmptyValidator,
                              onSaved: (newValue) =>
                                  _saveOnInstance('from.account', newValue),
                              keyboardType: TextInputType.number,
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
                        initialValue: _values['from.owner'],
                        onSaved: (newValue) =>
                            _saveOnInstance('from.owner', newValue),
                        decoration: InputDecoration(
                          labelText: 'Nome do titular',
                        ),
                      ),
                    )
                  ],
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
