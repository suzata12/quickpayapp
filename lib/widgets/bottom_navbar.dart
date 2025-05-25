import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlue30, // same as top nav background
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent, // so container color shows
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor:
            Colors.grey, // or Colors.white depending on your theme
        type: BottomNavigationBarType.fixed,
        elevation: 0, // remove shadow to match appbar look
        onTap: (index) {
          // Navigation logic (optional)
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'My Bills',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
