import 'package:start/models/account.dart';
import 'package:start/models/transaction.dart';

var transactions = {
  '12111429-6808-46bf-b700-68352cef54dd': Transaction(
    id: '12111429-6808-46bf-b700-68352cef54dd',
    type: 'TED',
    to: Account(
      agency: '1437',
      account: '3239-5',
      owner: 'Leonardo Braz',
    ),
    value: 5000.00,
    description: 'Movendo dinheiro para outra conta',
    date: DateTime.now(),
  ),
  '4e93cc3a-d02a-4b02-93cc-3bcedbdc8d08': Transaction(
    id: '4e93cc3a-d02a-4b02-93cc-3bcedbdc8d08',
    type: 'DOC',
    to: Account(
      agency: '4268',
      account: '13566-2',
      owner: 'Maria do Carmo Eugênia',
    ),
    value: 150.00,
    description: 'Pagamento de diarista',
    date: DateTime.now(),
  ),
  'f89bdfa6-4e47-4950-ab77-8309ce496c66': Transaction(
    id: 'f89bdfa6-4e47-4950-ab77-8309ce496c66',
    type: 'TED',
    to: Account(
      agency: '1890',
      account: '13544-2',
      owner: 'Lavras Imoveis Imobiliária Inc',
    ),
    value: 1100.00,
    description: 'Aluguel imobiliária',
    date: DateTime.now(),
  ),
};
