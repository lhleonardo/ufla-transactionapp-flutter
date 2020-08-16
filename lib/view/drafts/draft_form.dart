import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:start/models/draft.dart';

class DraftForm extends StatefulWidget {
  @override
  _DraftFormState createState() => _DraftFormState();
}

class _DraftFormState extends State<DraftForm> {
  final _formatter = DateFormat('dd/MM/yyyy');
  final _form = GlobalKey<FormState>();
  final Map<String, Object> _values = {};

  final _dateController = TextEditingController();
  Draft _openDraft;

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

  void _prepareFormData(Draft draft) {
    if (draft != null) {
      _openDraft = draft;
      _values["id"] = draft.id;
      _values["value"] = draft.value == null ? "" : draft.value;
      _values["date"] = draft.date;
      _dateController.text = _formatter.format(draft.date);

      _values["description"] = draft.description;

      _values["receiver"] = draft.receiver;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Draft transaction = ModalRoute.of(context).settings.arguments;
    _prepareFormData(transaction);
  }

  void _save() async {
    Map<String, Object> data = {
      'description': _values['description'],
      'value': _values['value'],
      'date': _values['date'],
      'receiver': _values['receiver']
    };
    if (_values.containsKey('id')) {
      // update
      await Firestore.instance
          .collection('drafts')
          .document(_values['id'])
          .setData(data);
    } else {
      // insert
      await Firestore.instance.collection('drafts').add(data);
    }
  }

  void _delete() async {
    await Firestore.instance
        .collection('drafts')
        .document(_values['id'])
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _openDraft == null ? Text('Novo cheque') : Text('Editar cheque'),
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
                          "Essa ação não pode ser desfeita. Deseja realmente excluir o registro de cheque?"),
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
                      //     .remove(_openDraft);
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

              _form.currentState.save();

              _save();

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
                    decoration:
                        InputDecoration(labelText: 'Descrição do cheque'),
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: TextFormField(
                        validator: _textLimitedValidator,
                        initialValue: _values['receiver'],
                        onSaved: (newValue) =>
                            _saveOnInstance('receiver', newValue),
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
