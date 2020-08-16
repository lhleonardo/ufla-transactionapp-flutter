import 'package:flutter/material.dart';
import 'package:start/models/account.dart';

class Transaction {
  final String id;
  final String type;

  final String description;

  final Account to;
  final double value;

  final DateTime date;

  const Transaction({
    this.id,
    this.description,
    @required this.type,
    @required this.to,
    @required this.value,
    this.date,
  });
}
