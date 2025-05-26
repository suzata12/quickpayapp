import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../utils/mock_data.dart';
import '../widgets/bottom_navbar.dart';
import '../screens/add_new_bill_screen.dart';
import '../screens/pay_bill_screen.dart';
import '../screens/my_bills_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> enabledStatus = {};

  @override
  void initState() {
    super.initState();
    for (var bill in upcomingBills) {
      enabledStatus[bill['title'] ?? ''] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double sectionSpacing = 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue30,
        elevation: 0,
        title: const Text(
          'QuickPay',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          _roundedIconButton(Icons.notifications_none),
          const SizedBox(width: 8),
          _roundedIconButton(Icons.settings),
          const SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, $userName 👋', style: AppTextStyles.greeting),
            const SizedBox(height: sectionSpacing),

            // Wallet Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${walletBalance.toStringAsFixed(2)}',
                      style: AppTextStyles.balance,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Last Payment',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${"${lastPayment.toStringAsFixed(2)} $lastPaymentDate"}',
                      style: AppTextStyles.secondaryBalance,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PayBillScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'PAY BILL NOW',
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
            ),

            const SizedBox(height: sectionSpacing),

            // Quick Access
            Text('Quick Access', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              itemCount: quickActions.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                var action = quickActions[index];
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primaryBlue10,
                      child: Icon(action.icon, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(height: 8),
                    Text(action.label, style: AppTextStyles.quickAction),
                  ],
                );
              },
            ),

            const SizedBox(height: sectionSpacing),

            // Upcoming Bills
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming Bills', style: AppTextStyles.sectionTitle),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewBillScreen(),
                      ),
                    );
                  },
                  child: Text(
                    '+ Add New Bill',
                    style: TextStyle(color: AppColors.primaryBlue),
                  ),
                ),
              ],
            ),
            ...upcomingBills.map((bill) {
              final String title = bill['title'] ?? '';
              final String due = bill['due'] ?? '';
              final bool isEnabled = enabledStatus[title] ?? true;

              return ListTile(
                title: Text(title),
                subtitle: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        due,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Switch(
                  value: isEnabled,
                  onChanged: (value) {
                    setState(() {
                      enabledStatus[title] = value;
                    });
                  },
                  activeColor: AppColors.primaryBlue,
                  inactiveTrackColor: Colors.grey[300],
                  inactiveThumbColor: Colors.grey[400],
                ),
              );
            }),

            const SizedBox(height: 12),

            // Full-width See All Bills button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBillsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'SEE ALL BILLS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: sectionSpacing),

            // Payment History
            Text('Payment History', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            ...dashPaymentHistory.map((item) {
              final String status = item['status'] ?? '';
              final bool isPaid = status.toLowerCase() == 'paid';

              return ListTile(
                title: Text(item['title'] ?? ''),
                subtitle: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isPaid ? AppColors.primaryBlue10 : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isPaid ? Colors.green : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  '\$${(item['amount'] as double).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : Colors.black,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _roundedIconButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primaryBlue),
        onPressed: () {
          // TODO: Handle action
        },
      ),
    );
  }
}
