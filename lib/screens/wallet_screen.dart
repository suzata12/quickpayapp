import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/mock_data.dart'; // ensure this file contains `walletBalance` and `paymentHistory`
import '../widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_navbar.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  void _showAmountDialog({required bool isTopUp}) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isTopUp ? 'Top Up Wallet' : 'Withdraw from Wallet'),
            // color: AppColors.primaryBlue10,
            content: TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final input = amountController.text.trim();
                  final amount = double.tryParse(input);

                  if (amount == null || amount <= 0) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid amount'),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    if (isTopUp) {
                      walletBalance += amount;
                      paymentHistory.insert(0, {
                        'category': 'TopUp',
                        'amount': amount,
                        'date': DateFormat(
                          'MMM d, yyyy',
                        ).format(DateTime.now()),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Wallet topped up by \$${amount.toStringAsFixed(2)}',
                          ),
                        ),
                      );
                    } else {
                      if (amount > walletBalance) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Insufficient balance')),
                        );
                        return;
                      }
                      walletBalance -= amount;
                      paymentHistory.insert(0, {
                        'category': 'Withdraw',
                        'amount': -amount,
                        'date': DateFormat(
                          'MMM d, yyyy',
                        ).format(DateTime.now()),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Withdrew \$${amount.toStringAsFixed(2)}',
                          ),
                        ),
                      );
                    }
                  });

                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentTransactions =
        paymentHistory.take(6).toList();

    return Scaffold(
      appBar: customAppBar('My Wallet'),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Wallet balance
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Wallet Balance',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${walletBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showAmountDialog(isTopUp: true),
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Top Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAmountDialog(isTopUp: false),
                  icon: const Icon(Icons.remove_circle),
                  label: const Text('Withdraw'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Recent Transactions
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  recentTransactions.isEmpty
                      ? const Center(child: Text('No transactions found.'))
                      : ListView.separated(
                        itemCount: recentTransactions.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final tx = recentTransactions[index];
                          final amount = tx['amount'] ?? 0.0;
                          final isCredit = amount > 0;

                          return ListTile(
                            leading: Icon(
                              isCredit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isCredit ? Colors.green : Colors.red,
                            ),
                            title: Text(tx['category']),
                            subtitle: Text(tx['date']),
                            trailing: Text(
                              '${isCredit ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCredit ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
