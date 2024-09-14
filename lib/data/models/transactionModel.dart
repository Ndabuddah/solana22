class Transaction {
  final String tokenNumber;
  final DateTime date;
  final bool retrieved;

  Transaction({
    required this.tokenNumber,
    required this.date,
    required this.retrieved,
  });
}

final List<Transaction> mockTransactions = [
  Transaction(tokenNumber: "TXN001", date: DateTime.now().subtract(const Duration(days: 1)), retrieved: true),
  Transaction(tokenNumber: "TXN002", date: DateTime.now().subtract(const Duration(days: 2)), retrieved: false),
  Transaction(tokenNumber: "TXN003", date: DateTime.now().subtract(const Duration(days: 3)), retrieved: true),
  Transaction(tokenNumber: "TXN004", date: DateTime.now().subtract(const Duration(days: 4)), retrieved: false),
];
