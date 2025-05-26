import '../models/quick_action.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

String userName = "Surya";
double walletBalance = 300.00;
double lastPayment = 306.50;
String lastPaymentDate = 'April-05';

List<QuickAction> quickActions = [
  QuickAction(label: 'Utilities', icon: Icons.lightbulb),
  QuickAction(label: 'Internet', icon: Icons.wifi),
  QuickAction(label: 'Water', icon: Icons.water),
  QuickAction(label: 'Rent', icon: Icons.home),
];

List<Map<String, String>> upcomingBills = [
  {'title': 'Electricity Bill', 'due': 'Due in 2 days'},
  {'title': 'Internet Bill', 'due': 'Due in 15 days'},
];

List<Map<String, dynamic>> dashPaymentHistory = [
  {'title': 'Water Bill', 'status': 'Paid', 'amount': 100.00},
  {'title': 'Electricity Bill', 'status': 'Due in 12 days', 'amount': 100.00},
  {'title': 'Internet Bill', 'status': 'Due in 18 days', 'amount': 25.50},
  {'title': 'Rent', 'status': 'Due in May 22', 'amount': 425.50},
];

final List<String> categories = ['Electricity', 'Water', 'Internet', 'Phone'];
final List<String> providers = ['ABC Company', 'XYZ Services', 'PowerGrid'];
final List<String> frequencies = ['One Time', 'Monthly', 'Quarterly', 'Yearly'];

const Map<String, dynamic> dummyBillSummary = {
  "category": "Utilities",
  "companyName": "ABC Company",
  "accountNumber": "****123",
  "paymentMethod": "Visa",
  "dueDate": "April 11, 2025",
  "amount": 50.00,
  "encryption": "123- encryption",
  "agreementAccepted": true,
};

List<Map<String, dynamic>> mockBills = [
  {
    'name': 'Internet Bill',
    'amount': 125.50,
    'status': 'due',
    'dueIn': 2,
    'frequency': '',
  },
  {
    'name': 'Electricity Bill',
    'amount': 200.00,
    'status': 'due',
    'dueIn': 10,
    'frequency': 'Monthly',
  },
  {
    'name': 'Water Bill',
    'amount': 25.50,
    'status': 'due',
    'dueIn': 12,
    'frequency': 'Monthly',
  },
  {
    'name': 'Netflix',
    'amount': 19.99,
    'status': 'paid',
    'dueIn': 0,
    'frequency': 'yearly',
  },
  {
    'name': 'Spotify',
    'amount': 10.99,
    'status': 'paid',
    'dueIn': 0,
    'frequency': '',
  },
];

final List<Map<String, dynamic>> paymentHistory = [
  {'category': 'Electricity', 'date': 'May 10, 2025', 'amount': -75.50},
  {'category': 'Internet', 'date': 'May 9, 2025', 'amount': -45.00},
  {'category': 'Rent', 'date': 'May 1, 2025', 'amount': -1200.00},
  {'category': 'TopUp', 'date': 'April 29, 2025', 'amount': 300.00},
  {'category': 'Withdraw', 'date': 'April 28, 2025', 'amount': -150.00},
  {'category': 'Electricity', 'date': 'April 15, 2025', 'amount': -80.75},
  {'category': 'Internet', 'date': 'April 10, 2025', 'amount': -43.25},
  {'category': 'TopUp', 'date': 'April 5, 2025', 'amount': 200.00},
  {'category': 'Rent', 'date': 'April 1, 2025', 'amount': -1200.00},
  {'category': 'Withdraw', 'date': 'March 30, 2025', 'amount': -100.00},
];

final mockUser = User(
  name: 'Emma Watson',
  email: 'emma@gmail.com',
  phone: '+61 400 123 456',
  profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/847/847969.png',
);
