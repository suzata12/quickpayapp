import 'package:flutter/material.dart';
import '../models/payment.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: ListTile(
        title: Text('Payment \$${payment.amount.toStringAsFixed(2)}'),
        subtitle: Text(
          'Date: ${payment.date.toLocal().toString().split(' ')[0]}',
        ),
      ),
    );
  }
}
