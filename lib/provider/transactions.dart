import 'package:flutter/material.dart';
import 'package:start/models/transaction.dart';
import 'package:start/data/transactions_mock.dart';
import 'package:uuid/uuid.dart';

/// Coleção centralizada de transações do app, utilizando
/// ideia de contexto geral
class Transactions with ChangeNotifier {
  Map<String, Transaction> _items = {...transactions};

  /// Retorna todas as transações em uma nova referência de memória
  List<Transaction> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  /// Encontra uma transação pelo seu identificador. Poderá retornar null.
  Transaction byIndex(int index) {
    return _items.values.elementAt(index);
  }

  void put(Transaction transaction) {
    if (transaction == null) return;
    if (transaction.id == null) {
      // os identificadores de transações são UUIDs
      final id = Uuid().v4();

      _items.putIfAbsent(
        id,
        () => Transaction(
          from: transaction.from,
          to: transaction.to,
          value: transaction.value,
          date: transaction.date,
          id: id,
          description: transaction.description,
          type: transaction.type,
        ),
      );
    } else {
      _items.update(
        transaction.id,
        (_) => transaction,
      );
    }

    notifyListeners();
  }

  /// Remove uma transação da coleção de transações,
  /// filtrando a partir de seu identificador e
  /// notificando seus ouvintes caso a ação tenha sido completa
  void remove(Transaction transaction) {
    if (transaction != null && transaction.id.isNotEmpty) {
      // só notifica as mudanças se realmente existia uma transação cadastrada
      if (_items.remove(transaction.id) != null) {
        notifyListeners();
      }
    }
  }
}
