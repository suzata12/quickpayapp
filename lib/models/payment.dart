class Payment {
  final String id;
  final String billId;
  final double amount;
  final DateTime date;

  Payment({
    required this.id,
    required this.billId,
    required this.amount,
    required this.date,
  });
}
