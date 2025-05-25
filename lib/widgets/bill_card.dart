import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BillCard extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillCard({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    String statusText = '';
    Color statusColor = Colors.black;

    if (bill['status'] == 'due') {
      statusText = 'Due in ${bill['dueIn']} days';
      statusColor = Colors.redAccent;
    } else if (bill['status'] == 'paid') {
      statusText = 'Paid';
      statusColor = Colors.green;
    } else {
      statusText = 'Pending';
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bill['name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$ ${bill['amount'].toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 14,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (bill['status'] != 'paid')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to payment
                  },
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
