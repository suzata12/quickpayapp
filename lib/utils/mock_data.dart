import '../models/quick_action.dart';
import 'package:flutter/material.dart';

String userName = "Surya";
double walletBalance = 300.00;

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

List<Map<String, dynamic>> paymentHistory = [
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
    'frequency': 'Monthly',
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
    'frequency': 'Monthly',
  },
  {
    'name': 'Spotify',
    'amount': 10.99,
    'status': 'paid',
    'dueIn': 0,
    'frequency': 'Monthly',
  },
];
