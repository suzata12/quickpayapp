import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bill_card.dart';
import '../utils/mock_data.dart';
import '../screens/add_new_bill_screen.dart';
import '../widgets/bottom_navbar.dart';

class MyBillsScreen extends StatefulWidget {
  const MyBillsScreen({super.key});

  @override
  State<MyBillsScreen> createState() => _MyBillsScreenState();
}

class _MyBillsScreenState extends State<MyBillsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _filters = ['Days', 'Amount'];
  String _selectedFilter = 'Days';
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Map<String, dynamic>> _getBills(String tab) {
    List<Map<String, dynamic>> filteredBills =
        mockBills.where((bill) {
          switch (tab) {
            case 'Upcoming':
              return bill['status'] == 'due';
            case 'Recurring':
              return bill['frequency'] != null &&
                  bill['frequency'].toString().trim().isNotEmpty;
            case 'Paid':
              return bill['status'] == 'paid';
            default:
              return true;
          }
        }).toList();

    // Sort logic
    if (_selectedFilter == 'Days') {
      filteredBills.sort((a, b) {
        int aDue = a['dueIn'] ?? 0;
        int bDue = b['dueIn'] ?? 0;
        return _ascending ? aDue.compareTo(bDue) : bDue.compareTo(aDue);
      });
    } else if (_selectedFilter == 'Amount') {
      filteredBills.sort((a, b) {
        double aAmt = a['amount']?.toDouble() ?? 0.0;
        double bAmt = b['amount']?.toDouble() ?? 0.0;
        return _ascending ? aAmt.compareTo(bAmt) : bAmt.compareTo(aAmt);
      });
    }

    return filteredBills;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('My Bills'),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      body: Column(
        children: [
          Container(
            color: AppColors.primaryBlue30,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryBlue,
              unselectedLabelColor: Colors.white,
              indicatorColor: AppColors.primaryBlue,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Recurring'),
                Tab(text: 'Paid'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text('Filter By:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items:
                      _filters
                          .map(
                            (f) => DropdownMenuItem(value: f, child: Text(f)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
                const SizedBox(width: 20),
                const Text('Order:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<bool>(
                  value: _ascending,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Ascending')),
                    DropdownMenuItem(value: false, child: Text('Descending')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _ascending = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:
                  ['Upcoming', 'Recurring', 'Paid'].map((tab) {
                    final bills = _getBills(tab);
                    return bills.isEmpty
                        ? const Center(child: Text('No bills found.'))
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: bills.length,
                          itemBuilder: (context, index) {
                            return BillCard(bill: bills[index]);
                          },
                        );
                  }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewBillScreen()),
          );
        },
        backgroundColor: AppColors.primaryBlue,
        label: const Text(
          'Add New Bill',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
