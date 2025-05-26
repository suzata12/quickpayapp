import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_new_bill_screen.dart';
import 'screens/my_bills_screen.dart';
import 'screens/pay_bill_screen.dart';
import 'screens/payment_history_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/my_profile_screen.dart';
import 'theme.dart';

void main() {
  runApp(const QuickPayApp());
}

class QuickPayApp extends StatelessWidget {
  const QuickPayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickPay',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add_bill': (context) => const AddNewBillScreen(),
        '/my_bills': (context) => const MyBillsScreen(),
        '/pay_bill': (context) => const PayBillScreen(),
        '/payment_history': (context) => const PaymentHistoryScreen(),
        '/wallet': (context) => const MyWalletScreen(),
        '/my_profile': (context) => const MyProfileScreen(),
      },
    );
  }
}
