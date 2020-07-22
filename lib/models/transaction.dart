import 'package:flutter/material.dart';
import 'package:start/models/account.dart';

class Transaction {
  final String id;
  final String type;

  final String description;

  final Account from;
  final Account to;
  final double value;

  const Transaction({
    this.id,
    this.description,
    @required this.type,
    @required this.from,
    @required this.to,
    @required this.value,
  });
}
