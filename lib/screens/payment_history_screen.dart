import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/mock_data.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_navbar.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Electricity',
    'Internet',
    'Rent',
    'TopUp',
    'Withdraw',
  ];

  List<Map<String, dynamic>> _getFilteredPayments() {
    List<Map<String, dynamic>> filtered =
        paymentHistory.where((payment) {
          final category = (payment['category'] ?? '').toString().toLowerCase();
          final date = (payment['date'] ?? '').toString().toLowerCase();

          final matchesCategory =
              _selectedCategory == 'All' ||
              category == _selectedCategory.toLowerCase();

          final matchesSearch =
              _searchQuery.isEmpty ||
              category.contains(_searchQuery.toLowerCase()) ||
              date.contains(_searchQuery.toLowerCase());

          return matchesCategory && matchesSearch;
        }).toList();

    // Sort by date (most recent first)
    filtered.sort((a, b) {
      final dateA = _parseDate(a['date']);
      final dateB = _parseDate(b['date']);
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime(2000);
    try {
      return DateFormat('MMM d, yyyy').parse(dateStr);
    } catch (_) {
      return DateTime(2000);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPayments = _getFilteredPayments();

    return Scaffold(
      appBar: customAppBar('Payment History'),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Date: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Filter By:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items:
                      _categories
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Transaction List:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  filteredPayments.isEmpty
                      ? const Center(child: Text('No payment records found.'))
                      : ListView.separated(
                        itemCount: filteredPayments.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final payment = filteredPayments[index];
                          final category = payment['category'] ?? 'Unknown';
                          final date = payment['date'] ?? '';
                          final rawAmount = payment['amount'];
                          final amount =
                              rawAmount is double
                                  ? rawAmount
                                  : double.tryParse(rawAmount.toString()) ??
                                      0.0;

                          return ListTile(
                            title: Text(category),
                            subtitle: Text(date),
                            trailing: Text(
                              amount >= 0
                                  ? '+\$${amount.toStringAsFixed(2)}'
                                  : '-\$${amount.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: amount >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  // Optional: Implement pagination later
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Load more functionality not implemented'),
                    ),
                  );
                },
                child: const Text(
                  'View More',
                  style: TextStyle(color: AppColors.primaryBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
