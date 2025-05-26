class Bill {
  final String category;
  final String companyName;
  final String accountName;
  final double amount;
  final String accountNumber;
  final int splitCount;

  Bill({
    required this.category,
    required this.companyName,
    required this.accountName,
    required this.amount,
    required this.accountNumber,
    this.splitCount = 1,
  });

  double get splitAmount => amount / splitCount;
}
