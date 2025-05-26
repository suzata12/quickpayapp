import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Do nothing if already on the page

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/payment_history');
        break;
      case 2:
        // Placeholder for Wallets screen
        Navigator.pushReplacementNamed(context, '/wallet');
        break;
      case 3:
        // Placeholder for My Bills screen
        Navigator.pushReplacementNamed(context, '/my_bills');
        break;
      case 4:
        // Placeholder for Profile screen
        Navigator.pushReplacementNamed(context, '/my_profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlue30,
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) => _onTabTapped(context, index),
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
